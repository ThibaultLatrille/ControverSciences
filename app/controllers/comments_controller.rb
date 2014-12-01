class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def new
    @comment = Comment.new()
    if params[:comment_id]
      @comment = Comment.find(params[:comment_id])
      session[:reference_id] = @comment.reference_id
      session[:timeline_id] = @comment.timeline_id
    end
    unless session[:reference_id]
      reference = Reference.select(:id, :timeline_id).find(params[:reference_id])
      session[:reference_id] = reference.id
      session[:timeline_id] = reference.timeline_id
    end
    @list = Reference.where( timeline_id: session[:timeline_id] ).pluck( :title, :id )
  end

  def create
      @comment = Comment.new({user_id: current_user.id,
              reference_id: session[:reference_id], timeline_id: session[:timeline_id]})
      for fi in 1..5
        @comment["f_#{fi}_content".to_sym ] = comment_params[ "f_#{fi}_content".to_sym ]
      end
      parent_id = comment_params[:id]
      if @comment.save_with_markdown( timeline_url( session[:timeline_id] ) )
        if parent_id
          CommentRelationship.create(parent_id: parent_id, child_id: @comment.id)
        end
        flash[:success] = "Edition enregistré"
        redirect_to comment_path(@comment.id)
      else
        @list = Reference.where( timeline_id: session[:timeline_id] ).pluck( :title, :id )
        render 'new'
      end
  end

  def show
    @comment = Comment.select( :id, :user_id, :reference_id, :timeline_id,
                               :markdown_1, :markdown_2, :markdown_3, :markdown_4,
                               :markdown_5, :balance, :best,
                               :created_at
                              ).find(params[:id])
    session[:reference_id] = @comment.reference_id
    session[:timeline_id] = @comment.timeline_id
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user_id == current_user.id && !comment.best
      comment.destroy_with_counters
      redirect_to my_items_comments_path
    else
      flash[:danger] = "Ce commentaire est le meilleur est ne peux être supprimer"
      redirect_to comment_path(params[:id])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:f_1_content, :f_2_content, :f_3_content, :f_4_content, :f_5_content, :id)
  end
end
