class FollowingNewTimelinesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    follow = FollowingNewTimeline.new( user_id: current_user.id)
    if follow.save
      flash[:success] = "Petit curieux, vous suivez maintenant toutes les nouvelles controverses"
    else
      flash[:danger] = "Vous êtes déjà attentif aux nouvelles controverses"
    end
    redirect_to timelines_path
  end

  def destroy
    fo = FollowingNewTimeline.find_by( user_id: current_user.id )
    unless fo.nil?
      fo.destroy
    end
    redirect_to followings_index_path
  end
end
