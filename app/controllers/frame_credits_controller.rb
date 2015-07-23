class FrameCreditsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    FrameCredit.where(user_id:     current_user.id,
                 timeline_id: params[:timeline_id]).destroy_all
    credit = FrameCredit.new({user_id:     current_user.id,
                         timeline_id: params[:timeline_id],
                         frame_id:  params[:frame_id]})
    if credit.save
      flash[:success] = "Mon vote a été pris en compte"
    else
      flash[:danger] = "Impossible d'effectuer cette action."
    end
    redirect_to frames_path( timeline_id: params[:timeline_id] )
  end

end
