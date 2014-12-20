class SummaryDraftsController < ApplicationController
  before_action :logged_in_user, only: [:destroy]
  def destroy
    summary = SummaryDraft.find(params[:id])
    if summary.user_id == current_user.id
      summary.destroy
    end
    redirect_to my_items_drafts_path
  end
end
