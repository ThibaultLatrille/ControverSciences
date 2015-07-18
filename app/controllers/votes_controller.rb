class VotesController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    Vote.where(user_id:     current_user.id, reference_id: params[:reference_id],
                 field: params[:field]).destroy_all
    vote = Vote.new({user_id:     current_user.id,
                         timeline_id: params[:timeline_id],
                         field: params[:field],
                         comment_id: params[:comment_id],
                         reference_id:  params[:reference_id]})
    if vote.save
      flash[:success] = "Votre vote a été pris en compte"
    else
      flash[:danger] = "Impossible d'effectuer cette action."
    end
    redirect_to reference_path(params[:reference_id])
  end
end
