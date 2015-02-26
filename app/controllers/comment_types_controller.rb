class CommentTypesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    type = CommentType.new( comment_types_params )
    type.target_user_id = Comment.select( :user_id ).find(comment_types_params[:comment_id]).user_id
    type.user_id = current_user.id
    if type.save
      respond_to do |format|
        format.js { render 'comment_types/success', :content_type => 'text/javascript', :layout => false}
      end
    else
      respond_to do |format|
        format.js { render 'comment_types/fail', :content_type => 'text/javascript', :layout => false}
      end
    end
  end

  private

  def comment_types_params
    params.require(:comment_type).permit(:comment_id, :content)
  end
end
