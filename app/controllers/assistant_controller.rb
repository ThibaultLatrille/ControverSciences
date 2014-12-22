class AssistantController < ApplicationController
  before_action :admin_user, only: [:view, :index, :users, :timelines, :selection, :fitness]

  def view
    session[:timeline_id] = nil
    session[:reference_id] = nil
  end

  def index
    pending_users = Hash[PendingUser.all.pluck( :user_id, :why)]
    @users = User.where( id: pending_users.keys  )
    @users.each do |user|
      user.why = pending_users[user.id]
    end
  end

  def users
    users = User.select(:id, :score).all
    users.each do |user|
      score_comments = 10*Math.log(BestComment.where( user_id: user.id).count + 1)
      score_summaries = 10*Math.log(SummaryBest.where( user_id: user.id).count + 1)
      score_references = 5*Math.log(Reference.where( user_id: user.id, star_most: [4,5], star_counted: true ).count + 1)
      score_timeline = 0.5*Math.log(Timeline.where( user_id: user.id).pluck( :score ).reduce(0,:+) + 1)
      score = 4.0/(1.0/(1+score_comments)+1.0/(1+score_summaries)+1.0/(1+score_references)+1.0/(1+score_timeline))
      User.update( user.id , score: score)
    end
    flash[:success] = "Les valeurs sélectives des utilisateurs sont à jour"
    redirect_to assistant_path
  end

  def timelines
    timelines = Timeline.select( :id, :nb_contributors, :nb_references, :nb_edits ).all
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
    flash[:success] = "Les valeurs sélectives des controverses sont à jour"
    redirect_to assistant_path
  end

  def fitness
    comments = Comment.all.pluck( :id )
    comments.each do |comment_id|
      votes = Vote.select( :user_id, :value, :reference_id ).where( comment_id: comment_id)
      score = 0.0
      votes.each do |vote|
        time = Time.now-VisiteReference.select( :updated_at ).find_by( user_id: vote.user_id,
                                      reference_id: vote.reference_id ).updated_at
        scale = 1
        if time > 2592000
          # Using the log-logistic cumulative distribution function for it's nice properties
          # 7776000 is 3 months and 2592000 is a month. So in 4 month after the visit the scale is 0.5 and 1 after a month
          scale = 1-1/( 1 + (7776000/(time - 2592000))**5 )
        end
        score += scale*User.select( :score ).find( vote.user_id ).score*vote.value
      end
      Comment.update( comment_id, score: score)
    end
    summaries = Summary.all.pluck( :id )
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
      Summary.update( summary_id, score: score)
    end
    flash[:success] = "Les valeurs sélectives des analyses sont à jour"
    redirect_to assistant_path
  end

  def selection
    references = Reference.all.pluck( :id )
    references.each do |reference_id|
    most = Comment.where( reference_id: reference_id ).order(score: :desc).first
    best_comment = BestComment.find_by(reference_id: reference_id )
      if most
        if most.id != best_comment.comment_id
            most.selection_update( best_comment )
        end
      end
    end
    timelines = Timeline.all.pluck( :id )
    timelines.each do |timeline_id|
      most = Summary.where( timeline_id: timeline_id ).order(score: :desc).first
      best_summary = SummaryBest.find_by(timeline_id: timeline_id )
      if most
        if most.id != best_summary.summary_id
          most.selection_update( best_summary )
        end
      end
    end
    flash[:success] = "La sélection a opéré"
    redirect_to assistant_path
  end
end