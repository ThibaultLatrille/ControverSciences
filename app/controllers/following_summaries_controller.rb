class FollowingSummariesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    follow = FollowingSummary.new( user_id: current_user.id,
                                     timemline_id: params[:timemline_id])
    if follow.save
      flash[:success] = "Abonnement confirmé"
    else
      flash[:danger] = "Vous suivez déjà les résumés de cette controverse avec attention"
    end
    redirect_to summaries_path( timeline_id: params[:timemline_id])
  end

  def destroy
    fo = FollowingSummary.find_by( user_id: current_user.id, timemline_id: params[:timemline_id] )
    unless fo.nil?
      fo.destroy
    end
    redirect_to followings_index_path
  end
end
