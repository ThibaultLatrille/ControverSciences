class FrameCreditsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    FrameCredit.where(user_id:     current_user.id,
                 timeline_id: params[:timeline_id]).destroy_all
    credit = FrameCredit.new({user_id:     current_user.id,
                         timeline_id: params[:timeline_id],
                         frame_id:  params[:frame_id]})
    if credit.save
      flash[:success] = "Votre vote a été pris en compte"
    else
      flash[:danger] = "Impossible d'effectuer cette action."
    end
    redirect_to frames_path( timeline_id: params[:timeline_id] )
  end

  def destroy
    frame_credit = FrameCredit.find(params[:id])
    if frame_credit.user_id == current_user.id ||current_user.admin
      frame_credit.destroy
    end
    redirect_to :back
  end

end
