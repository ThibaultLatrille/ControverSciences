class FollowingTimelinesController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    follow = FollowingTimeline.new( user_id: current_user.id,
                                    timeline_id: params[:timeline_id])
    if follow.save
      flash[:success] = "Abonnement confirmé"
    else
      flash[:danger] = "Vous suivez déjà cette controverse avec attention"
    end
    redirect_to timeline_path(params[:timeline_id])
  end
end
