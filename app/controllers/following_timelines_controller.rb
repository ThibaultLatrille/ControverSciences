class FollowingTimelinesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    follow = FollowingTimeline.new( user_id: current_user.id,
                                    timeline_id: params[:timeline_id])
    if follow.save
      flash[:success] = "Vous serez notifié des nouvelles références de cette controverse."
    else
      flash[:danger] = "Vous suivez déjà cette controverse."
    end
    redirect_to timeline_path(params[:timeline_id])
  end

  def destroy
    fo = FollowingTimeline.find_by( user_id: current_user.id, timeline_id: params[:id] )
    unless fo.nil?
      fo.destroy
    end
    redirect_to followings_index_path
  end
end
