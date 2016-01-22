class FrameCreditsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    FrameCredit.where(user_id:     current_user.id,
                 timeline_id: params[:timeline_id]).destroy_all
    frame_credit = FrameCredit.new({user_id:     current_user.id,
                         timeline_id: params[:timeline_id],
                         frame_id:  params[:frame_id]})
    if frame_credit.save
      frame_credit.update_frame
      flash[:success] = t('controllers.vote_ok')
    else
      flash[:danger] = t('controllers.impossible_action')
    end
    redirect_to frames_path( timeline_id: params[:timeline_id] )
  end

  def destroy
    frame_credit = FrameCredit.find(params[:id])
    if frame_credit.user_id == current_user.id ||current_user.admin
      frame_credit.destroy
      frame_credit.update_frame
    end
    redirect_to_back
  end

end
