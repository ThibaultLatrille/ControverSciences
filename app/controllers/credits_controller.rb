class CreditsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    Credit.where(user_id:     current_user.id,
                 timeline_id: params[:timeline_id]).destroy_all
    credit = Credit.new({user_id:     current_user.id,
                         timeline_id: params[:timeline_id],
                         summary_id:  params[:summary_id]})
    if credit.save
      credit.update_summary
      flash[:success] = t('controllers.vote_ok')
    else
      flash[:danger] = t('controllers.impossible_action')
    end
    redirect_to summaries_path(timeline_id: params[:timeline_id])
  end

  def destroy
    credit = Credit.find(params[:id])
    if credit.user_id == current_user.id ||current_user.admin
      credit.destroy
      credit.update_summary
    end
    redirect_to_back
  end
end
