class FrameCreditsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    my_frame_credit = FrameCredit.find_by({user_id: current_user.id,
                            frame_id: frame_credit_params[:frame_id]})
    if my_frame_credit
      if frame_credit_params[:value] == "0"
        my_frame_credit.destroy_with_counters
        flash[:success] = "Le nombre de crédits accordés à cette contribution a été modifié."
      else
        if my_frame_credit.update( {value: frame_credit_params[:value]})
          flash[:success] = "Le nombre de crédits accordés à cette contribution a été modifié."
        else
          flash[:danger] = "Impossible d'effectuer cette action."
        end
      end
    elsif frame_credit_params[:value] != "0"
      frame_credit = FrameCredit.new({user_id: current_user.id,
                       timeline_id: frame_credit_params[:timeline_id],
                       frame_id: frame_credit_params[:frame_id],
                       value: frame_credit_params[:value]})
      if frame_credit.save
        flash[:success] = "Le nombre de crédits accordés à cette contribution a été modifié."
      else
        flash[:danger] = "Impossible d'effectuer cette action."
      end
    else
      flash[:danger] = "Impossible d'effectuer cette action."
    end
    redirect_to frames_path( timeline_id: frame_credit_params[:timeline_id] )
  end

  def destroy
    if params[:id]=='all'
      frame_credits = FrameCredit.where( user_id: current_user.id, timeline_id: params[:timeline_id])
      frame_credits.each do |frame_credit|
        frame_credit.destroy_with_counters
      end
      redirect_to frames_path( timeline_id: params[:timeline_id] )
    elsif params[:id]=='none'
      frame_credit = FrameCredit.find_by(frame_id: params[:frame_id], user_id: current_user.id )
      timeline_id = frame_credit.timeline_id
      frame_credit.destroy_with_counters
      redirect_to frames_path( timeline_id: timeline_id )
    else
      frame_credits = FrameCredit.find(params[:id])
      if frame_credits.user_id == current_user.id
        frame_credits.destroy_with_counters
        redirect_to my_items_votes_path
      end
    end
  end

  private

  def frame_credit_params
    params.require(:frame_credit).permit(:timeline_id, :frame_id, :value)
  end
end
