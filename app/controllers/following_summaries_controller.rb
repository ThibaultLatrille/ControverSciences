class FollowingSummariesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    follow = FollowingSummary.new( user_id: current_user.id,
                                     timeline_id: params[:timeline_id])
    if follow.save
      flash[:success] = "Abonnement confirmé"
    else
      flash[:danger] = "Vous suivez déjà les synthèses de cette controverse avec attention"
    end
    redirect_to summaries_path( timeline_id: params[:timeline_id])
  end

  def destroy
    fo = FollowingSummary.find_by( user_id: current_user.id, timeline_id: params[:id] )
    unless fo.nil?
      fo.destroy
    end
    redirect_to followings_index_path
  end
end
