module AssisstantHelper

  def update_score_users
    users = User.select(:id, :score).all
    users.each do |user|
      count = 1
      for field in 0..7 do
        count += BestComment.where( "f_#{field}_user_id".to_sym => user.id).count
      end
      score_comments = 2*Math.log( count )
      score_summaries = 10*Math.log(SummaryBest.where( user_id: user.id).count + 1)
      score_references = 5*Math.log(Reference.where( user_id: user.id, star_most: [4,5] ).count + 1)
      score_timeline = 0.5*Math.log(Timeline.where( user_id: user.id).pluck( :score ).reduce(0,:+) + 1)
      score = 4.0/(1.0/(1+score_comments)+1.0/(1+score_summaries)+1.0/(1+score_references)+1.0/(1+score_timeline))
      User.update( user.id , score: score)
    end
  end

  def update_score_timelines
    timelines = Timeline.select( :id, :nb_contributors, :nb_references, :nb_summaries, :nb_comments ).all
    timelines.each do |timeline|
      ago = Time.now - 7.days
      nb_references = Reference.where( timeline_id: timeline.id, created_at: ago..Time.now).count
      nb_edits = Comment.where( timeline_id: timeline.id, created_at: ago..Time.now).count +
          Summary.where( timeline_id: timeline.id, created_at: ago..Time.now).count
      nb_contributors = TimelineContributor.where( timeline_id: timeline.id, created_at: ago..Time.now).count
      score = timeline.compute_score( timeline.nb_contributors, timeline.nb_references, timeline.nb_edits )
      recent_score = timeline.compute_score( nb_contributors, nb_references, nb_edits )
      Timeline.update( timeline.id, score_recent: recent_score, score: score)
    end
  end

  def compute_fitness
    comments = Comment.where( public: true).pluck( :id )
    comments.each do |comment_id|
      score = {0 => 0.0, 1 => 0.0, 2 => 0.0, 3 => 0.0, 4 => 0.0, 5 => 0.0, 6 => 0.0, 7 => 0.0}
      Vote.select( :user_id, :value, :reference_id, :field ).where( comment_id: comment_id ).group_by{ |vote| vote.field }.map do | field, votes_by_field|
        votes_by_field.each do |vote|
          time = Time.now-VisiteReference.select( :updated_at ).find_by( user_id: vote.user_id,
                                                                         reference_id: vote.reference_id ).updated_at
          scale = 1
          if time > 2592000
            # Using the log-logistic cumulative distribution function for it's nice properties
            # 7776000 is 3 months and 2592000 is a month. So in 4 month after the visit the scale is 0.5 and 1 after a month
            scale = 1-1/( 1 + (7776000/(time - 2592000))**5 )
          end
          score[field] += scale*User.select( :score ).find( vote.user_id ).score*vote.value
        end
      end
      Comment.where(id: comment_id).update_all(  f_0_score: score[0], f_1_score: score[1], f_2_score: score[2], f_3_score: score[3], f_4_score: score[4],
                      f_5_score: score[5], f_6_score: score[6], f_7_score: score[7])
    end
    summaries = Summary.where( public: true ).pluck( :id )
    summaries.each do |summary_id|
      credits = Credit.select( :user_id, :value, :timeline_id ).where( summary_id: summary_id)
      score = 0.0
      credits.each do |credit|
        time = Time.now-VisiteTimeline.select( :updated_at ).find_by( user_id: credit.user_id,
                                                                      timeline_id: credit.timeline_id ).updated_at
        scale = 1
        if time > 2592000
          # Using the log-logistic cumulative distribution function for it's nice properties
          # 7776000 is 3 months and 2592000 is a month. So in 4 month after the visit the scale is 0.5 and 1 after a month
          scale = 1-1/( 1 + (7776000/(time - 2592000))**5 )
        end
        score += scale*User.select( :score ).find( credit.user_id ).score*credit.value
      end
      Summary.where(id: summary_id).update_all( score: score)
    end
  end

  def get_most_comment(reference_id, field)
    ids = CommentJoin.where( reference_id: reference_id, field: field ).pluck( :comment_id )
    if field == 6
      most = Comment.select( :id, :reference_id, :title_markdown, :user_id, "f_#{field}_score",
                             "f_#{field}_balance" ).where( id: ids ).order(:f_6_score => :desc).first
    else
      most = Comment.select( :id, :reference_id, :user_id, "f_#{field}_score",
                             "f_#{field}_balance" ).where( id: ids ).order( "f_#{field}_score".to_sym => :desc).first
    end
    most
  end

  def update_best_comment(reference_id, field)
    best_comment = BestComment.find_by(reference_id: reference_id )
    unless best_comment
      best_comment = BestComment.new(reference_id: reference_id)
    end
    most = get_most_comment(reference_id, field)
    if most
      if (most.id != best_comment["f_#{field}_comment_id".to_sym]) && (most["f_#{field}_balance"] != 0)
        most.selection_update( best_comment,
                               best_comment["f_#{field}_comment_id".to_sym],
                               best_comment["f_#{field}_user_id".to_sym], field ).save
      end
    end
  end

  def selection_events
    references = Reference.all.pluck( :id )
    references.each do |reference_id|
      for field in 0..7 do
        update_best_comment(reference_id, field )
      end
    end
    timelines = Timeline.all.pluck( :id )
    timelines.each do |timeline_id|
      most = Summary.where( timeline_id: timeline_id, public: true ).order(score: :desc).first
      best_summary = SummaryBest.find_by(timeline_id: timeline_id )
      if most
        if (most.id != best_summary.summary_id) && (most.balance != 0)
          most.selection_update( best_summary )
        end
      end
    end
  end

  def generate_notifications
    # JOIN NEEDED
    new_timelines = NewTimeline.all.pluck( :timeline_id )
    new_timelines.each do |timeline_id|
      timeline = Timeline.find_by( id: timeline_id )
      tag_ids = timeline.tags.pluck(:id)
      user_ids = FollowingNewTimeline.where( tag_id: tag_ids ).pluck( :user_id )
      user_ids.uniq!
      notifications = []
      user_ids.each do |user_id|
        notifications << NotificationTimeline.new( user_id: user_id, timeline_id: timeline_id )
      end
      NotificationTimeline.import notifications
    end
    NewTimeline.where(timeline_id: new_timelines ).destroy_all

    new_references = NewReference.all.pluck( :reference_id )
    new_references.each do |reference_id|
      reference = Reference.select(:id, :timeline_id).find_by( id: reference_id )
      if reference
        user_ids = FollowingTimeline.where( timeline_id: reference.timeline_id ).pluck( :user_id )
        notifications = []
        user_ids.each do |user_id|
          notifications << NotificationReference.new( user_id: user_id, reference_id: reference.id )
        end
        NotificationReference.import notifications
      end
    end
    NewReference.where(reference_id: new_references ).destroy_all

    new_summaries = NewSummary.all.pluck( :summary_id )
    new_summaries.each do |summary_id|
      summary = Summary.select(:id, :timeline_id).find_by( id: summary_id )
      if summary
        user_ids = FollowingSummary.where( timeline_id: summary.timeline_id ).pluck( :user_id )
        notifications = []
        user_ids.each do |user_id|
          notifications << NotificationSummary.new( user_id: user_id, summary_id: summary.id )
        end
        NotificationSummary.import notifications
      end
    end
    NewSummary.where(summary_id: new_summaries ).destroy_all

    new_summaries = NewSummarySelection.all
    new_summaries.each do | summary_selection |
      summary = Summary.select(:id, :timeline_id).find_by( id: summary_selection.new_summary_id )
      if summary
        user_ids = FollowingSummary.where( timeline_id: summary.timeline_id ).pluck(:user_id )
        notifications = []
        user_ids.each do |user_id|
          notifications << NotificationSummarySelection.new( user_id: user_id, old_summary_id: summary_selection.old_summary_id,
                                                             new_summary_id: summary_selection.new_summary_id )
        end
        NotificationSummarySelection.import notifications
      end
    end
    NewSummarySelection.where( id: new_summaries.map{ |s| s.id } ).destroy_all

    new_comments = NewComment.all.pluck( :comment_id )
    new_comments.each do |comment_id|
      comment = Comment.select(:id, :reference_id).find_by( id: comment_id )
      if comment
        user_ids = FollowingReference.where( reference_id: comment.reference_id ).pluck( :user_id )
        notifications = []
        user_ids.each do |user_id|
          notifications << NotificationComment.new( user_id: user_id, comment_id: comment.id )
        end
        NotificationComment.import notifications
      end
    end
    NewComment.where(comment_id: new_comments ).destroy_all

    new_comments = NewCommentSelection.all
    new_comments.each do | comment_selection |
      comment = Comment.select(:id, :reference_id).find_by( id: comment_selection.new_comment_id )
      if comment
        user_ids = FollowingReference.where( reference_id: comment.reference_id ).pluck(:user_id )
        notifications = []
        user_ids.each do |user_id|
          notifications << NotificationSelection.new( user_id: user_id, old_comment_id: comment_selection.old_comment_id,
                                                      new_comment_id: comment_selection.new_comment_id, field: comment_selection.field )
        end
        NotificationSelection.import notifications
      end
    end
    NewCommentSelection.where( id: new_comments.map{ |s| s.id } ).destroy_all
  end
end
