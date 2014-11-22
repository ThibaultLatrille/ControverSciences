class AssistantController < ApplicationController
  before_action :admin_user, only: [:view, :users, :timelines, :selection, :fitness]

  def view
  end

  def users
    users = User.all
    users.each do |user|
      score_comments = Math.log(BestComment.where( user_id: user.id).count + 1)
      score_references = Math.log(Reference.where( user_id: user.id, star_most: [4,5], star_counted: true ).count + 1)
      score_timeline = Math.log(Timeline.where( user_id: user.id).pluck( :score ).reduce(0,:+) + 1)
      score = 3.0/(1.0/(1+score_comments)+1.0/(1+score_references)+1.0/(1+score_timeline))
      user.update_attributes( score: score)
    end
    flash[:success] = "Les valeurs sélectives des utilisateurs sont à jour"
    redirect_to assistant_path
  end

  def timelines
    timelines = Timeline.all
    timelines.each do |timeline|
      ago = Time.now - 7.days
      nb_references = Reference.where( timeline_id: timeline.id, created_at: ago..Time.now).count
      nb_comments = Comment.where( timeline_id: timeline.id, created_at: ago..Time.now).count
      nb_votes = Vote.where( timeline_id: timeline.id, created_at: ago..Time.now).count
      score = timeline.compute_score( timeline.nb_references, timeline.nb_edits, timeline.nb_votes)
      recent_score = timeline.compute_score( nb_references, nb_comments, nb_votes)
      timeline.update_attributes( score_recent: recent_score, score: score)
    end
    flash[:success] = "Les valeurs sélectives des controverses sont à jour"
    redirect_to assistant_path
  end

  def selection
    references = Reference.all
    references.each do |reference|
    most = Comment.where( reference_id: reference.id ).order(score: :desc).first
    if most
      if most.score > 3.0
        best_comment = BestComment.find_by(reference_id: reference.id )
        most.selection_update( best_comment )
        Vote.where( reference_id: reference.id ).destroy_all
      end
    end
    end
    flash[:success] = "La sélection a opérée"
    redirect_to assistant_path
  end

  def fitness
    comments = Comment.all
    comments.each do |comment|
      votes = Vote.where( comment_id: comment.id)
      score = 0.0
      votes.each do |vote|
        if vote.value == 1
          score += vote.user.score
        elsif vote.value == 0
          score -= vote.user.score
        end
      end
      comment.update_attributes( score: score)
    end
    flash[:success] = "Les valeurs sélectives des analyses sont à jour"
    redirect_to assistant_path
  end
end