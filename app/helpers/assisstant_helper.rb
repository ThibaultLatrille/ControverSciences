module AssisstantHelper

  def maj_v_3
    ActiveRecord::Base.transaction do
      Timeline.all.each do |timeline|
        frame = Frame.new( user_id: timeline.user_id, best: true, binary: timeline.binary,
                      content: "", name: timeline.name, timeline_id: timeline.id )
        frame.set_tag_list(timeline.get_tag_list)
        frame.save!
      end
      User.all.each do |user|
        user.update_columns( nb_notifs: user.notifications_all_important )
      end
    end
  end

  def maj_v_2
    ActiveRecord::Base.transaction do
      ethic = Tag.find_by(name: "ethics")
      Tagging.where( tag_id: ethic.id ).destroy_all
    end
  end

  def maj_v_1
    ActiveRecord::Base.transaction do
      Like.all.delete_all
      SuggestionVote.all.delete_all
      SuggestionChildVote.all.delete_all
      Timeline.all.update_all(nb_likes: 0)
      Suggestion.all.update_all(plus: 0, minus: 0, balance: 0)
      SuggestionChild.all.update_all(plus: 0, minus: 0, balance: 0)
      Timeline.where(debate: false).each do |tim|
        text = "Discussion libre autour de la controverse : **#{tim.name.strip}**"
        Suggestion.create!(user_id: tim.user_id, timeline_id: tim.id, comment: text)
      end
      Timeline.all.update_all(debate: true)
      Reference.all.each do |ref|
        ref.binary_1 = Binary.where( reference_id: ref.id, value: 1).count
        ref.binary_2 = Binary.where( reference_id: ref.id, value: 2).count
        ref.binary_3 = Binary.where( reference_id: ref.id, value: 3).count
        ref.binary_3 = Binary.where( reference_id: ref.id, value: 3).count
        ref.binary_5 = Binary.where( reference_id: ref.id, value: 5).count
        dico = { 1 => ref.binary_1, 2 => ref.binary_2,
                 3 => ref.binary_3, 4 => ref.binary_4,
                 5 => ref.binary_5}
        most = dico.max_by{ |k,v| v }
        if most[1] > 0
          ref.binary_most = most[0]
        else
          ref.binary_most = 0
        end
        ref.star_1 = Rating.where( reference_id: ref.id, value: 1).count
        ref.star_2 = Rating.where( reference_id: ref.id, value: 2).count
        ref.star_3 = Rating.where( reference_id: ref.id, value: 3).count
        ref.star_3 = Rating.where( reference_id: ref.id, value: 3).count
        ref.star_5 = Rating.where( reference_id: ref.id, value: 5).count
        dico = { 1 => ref.star_1, 2 => ref.star_2,
                 3 => ref.star_3, 4 => ref.star_4,
                 5 => ref.star_5}
        most = dico.max_by{ |k,v| v }
        if most[1] > 0
          ref.star_most = most[0]
        else
          ref.star_most = 0
        end
        ref.save!
      end
      Timeline.all.each do |tim|
        tim.binary_0 = Reference.where( timeline_id: tim.id, binary_most: 0).count
        tim.binary_1 = Reference.where( timeline_id: tim.id, binary_most: 1).count
        tim.binary_2 = Reference.where( timeline_id: tim.id, binary_most: 2).count
        tim.binary_3 = Reference.where( timeline_id: tim.id, binary_most: 3).count
        tim.binary_3 = Reference.where( timeline_id: tim.id, binary_most: 3).count
        tim.binary_5 = Reference.where( timeline_id: tim.id, binary_most: 5).count
        tim.save!
      end
    end
  end

  def update_score_users
    User.select(:id, :score).all.each do |user|
      count = 1
      for field in 0..7 do
        count += BestComment.where("f_#{field}_user_id".to_sym => user.id).count
      end
      score_comments   = 2*Math.log(count)
      score_summaries  = 10*Math.log(SummaryBest.where(user_id: user.id).count + 1)
      score_references = 5*Math.log(Reference.where(user_id: user.id, star_most: [4, 5]).count + 1)
      score_timeline   = 0.5*Math.log(Timeline.where(user_id: user.id).pluck(:score).reduce(0, :+) + 1)
      score            = 4.0/(1.0/(1+score_comments)+1.0/(1+score_summaries)+1.0/(1+score_references)+1.0/(1+score_timeline))
      User.update(user.id, score: score)
    end
  end

  def update_score_timelines
    Timeline.select(:id, :nb_contributors, :nb_references, :nb_summaries, :nb_comments).all.each do |timeline|
      ago             = Time.now - 7.days
      nb_references   = Reference.where(timeline_id: timeline.id, created_at: ago..Time.now).count
      nb_edits        = Comment.where(timeline_id: timeline.id, created_at: ago..Time.now).count +
          Summary.where(timeline_id: timeline.id, created_at: ago..Time.now).count
      nb_contributors = TimelineContributor.where(timeline_id: timeline.id, created_at: ago..Time.now).count
      score           = timeline.compute_score(timeline.nb_contributors, timeline.nb_references, timeline.nb_edits)
      recent_score    = timeline.compute_score(nb_contributors, nb_references, nb_edits)
      Timeline.update(timeline.id, score_recent: recent_score, score: score)
    end
  end

  def compute_fitness
    Comment.where(public: true).pluck(:id).each do |comment_id|
      score = {0 => 0.0, 1 => 0.0, 2 => 0.0, 3 => 0.0, 4 => 0.0, 5 => 0.0, 6 => 0.0, 7 => 0.0}
      Vote.select(:user_id, :value, :reference_id, :field).where(comment_id: comment_id).group_by { |vote| vote.field }.map do |field, votes_by_field|
        votes_by_field.each do |vote|
          time  = Time.now-VisiteReference.select(:updated_at).find_by(user_id:      vote.user_id,
                                                                       reference_id: vote.reference_id).updated_at
          scale = 1
          if time > 2592000
            # Using the log-logistic cumulative distribution function for it's nice properties
            # 7776000 is 3 months and 2592000 is a month. So in 4 month after the visit the scale is 0.5 and 1 after a month
            scale = 1-1/(1 + (7776000/(time - 2592000))**5)
          end
          score[field] += scale*User.select(:score).find(vote.user_id).score*vote.value
        end
      end
      Comment.where(id: comment_id).update_all(f_0_score: score[0], f_1_score: score[1], f_2_score: score[2], f_3_score: score[3], f_4_score: score[4],
                                               f_5_score: score[5], f_6_score: score[6], f_7_score: score[7])
    end
    Summary.where(public: true).pluck(:id).each do |summary_id|
      credits = Credit.select(:user_id, :value, :timeline_id).where(summary_id: summary_id)
      score   = 0.0
      credits.each do |credit|
        time  = Time.now-VisiteTimeline.select(:updated_at).find_by(user_id:     credit.user_id,
                                                                    timeline_id: credit.timeline_id).updated_at
        scale = 1
        if time > 2592000
          # Using the log-logistic cumulative distribution function for it's nice properties
          # 7776000 is 3 months and 2592000 is a month. So in 4 month after the visit the scale is 0.5 and 1 after a month
          scale = 1-1/(1 + (7776000/(time - 2592000))**5)
        end
        score += scale*User.select(:score).find(credit.user_id).score*credit.value
      end
      Summary.where(id: summary_id).update_all(score: score)
    end
  end

  def get_most_comment(reference_id, field)
    ids = CommentJoin.where(reference_id: reference_id, field: field).pluck(:comment_id)
    if field == 6
      most = Comment.select(:id, :reference_id, :timeline_id, :title_markdown, :user_id, "f_#{field}_score",
                            "f_#{field}_balance").where(id: ids).order(:f_6_score => :desc).first
    else
      most = Comment.select(:id, :reference_id, :timeline_id, :user_id, "f_#{field}_score",
                            "f_#{field}_balance").where(id: ids).order("f_#{field}_score".to_sym => :desc).first
    end
    most
  end

  def update_best_comment(reference_id, field)
    best_comment = BestComment.find_by(reference_id: reference_id)
    unless best_comment
      best_comment = BestComment.new(reference_id: reference_id)
    end
    most = get_most_comment(reference_id, field)
    if most
      if (most.id != best_comment["f_#{field}_comment_id".to_sym]) && (most["f_#{field}_balance"] != 0)
        most.selection_update(best_comment,
                              best_comment["f_#{field}_comment_id".to_sym],
                              best_comment["f_#{field}_user_id".to_sym], field).save
      end
    end
  end

  def selection_events
    Reference.all.pluck(:id).each do |reference_id|
      for field in 0..7 do
        update_best_comment(reference_id, field)
      end
    end
    Timeline.all.pluck(:id).each do |timeline_id|
      most         = Summary.where(timeline_id: timeline_id, public: true).order(score: :desc).first
      best_summary = SummaryBest.find_by(timeline_id: timeline_id)
      if most
        if (most.id != best_summary.summary_id) && (most.balance != 0)
          most.selection_update(best_summary)
        end
      end
    end
  end
end
