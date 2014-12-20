class CommentDraftsController < ApplicationController
  before_action :logged_in_user, only: [:destroy]
  def destroy
    comment = CommentDraft.find(params[:id])
    if comment.user_id == current_user.id
      comment.destroy
    end
    redirect_to my_items_drafts_path
  end
end
