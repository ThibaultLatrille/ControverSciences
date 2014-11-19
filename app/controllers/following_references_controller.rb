class FollowingReferencesController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    follow = FollowingReference.new( user_id: current_user.id,
                      reference_id: params[:reference_id])
    if follow.save
      flash[:success] = "Abonnement confirmé"
    else
      flash[:danger] = "Vous suivez déjà cette référence avec attention"
    end
    redirect_to reference_path(params[:reference_id])
  end
end
