class FollowingReferencesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

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

  def destroy
    fo = FollowingReference.find_by( user_id: current_user.id, reference_id: params[:id] )
    unless fo.nil?
      fo.destroy
    end
    redirect_to followings_index_path
  end
end
