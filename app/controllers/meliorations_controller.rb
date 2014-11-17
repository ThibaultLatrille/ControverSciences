class MeliorationsController < ApplicationController
  def new
    @comment = Comment.find(params[:comment_id])
    @melioration = Melioration.new(user_id: current_user.id, comment_id: @comment.id,
                   content: @comment.content,  to_user_id: @comment.user_id)
    @list = Reference.where( timeline_id: @comment.timeline_id ).pluck( :title, :id )
  end

  def create
    comment = Comment.find( melioration_params[:comment_id])
    @melioration = Melioration.new( user_id: current_user.id,
            comment_id: comment.id, to_user_id: comment.user_id,
            content: melioration_params[:content], message: melioration_params[:message] )
    if @melioration.save
      flash[:success] = "Amélioration envoyé"
      User.increment_counter(:pending_meliorations, comment.user_id)
      redirect_to reference_url( comment.reference_id )
    else
      render 'static_pages/home'
    end
  end

  def pending
    @meliorations = Melioration.where( to_user_id: current_user.id)
  end

  def index
    @meliorations = Melioration.where( user_id: current_user.id)
  end

  private

  def melioration_params
    params.require(:melioration).permit(:content, :message, :comment_id)
  end
end
