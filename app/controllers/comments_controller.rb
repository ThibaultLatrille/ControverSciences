class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def new
    @comment = Comment.new()
    if params[:comment_id]
      @comment = Comment.find(params[:comment_id])
      session[:reference_id] = @comment.reference_id
      session[:timeline_id] = @comment.timeline_id
    end
    unless session[:timeline_id]
      session[:reference_id] = params[:reference_id]
      session[:timeline_id] = params[:timeline_id]
    end
    @list = Reference.where( timeline_id: session[:timeline_id] ).pluck( :title, :id )
  end

  def create
      @comment = Comment.new({user_id: current_user.id,
              reference_id: session[:reference_id], timeline_id: session[:timeline_id]})
      for fi in 1..5
        @comment["content_#{fi}".to_sym ] = comment_params[ "content_#{fi}".to_sym ]
      end
      parent_id = comment_params[:id]
      if @comment.save_with_markdown( root_url )
        if parent_id
          CommentRelationship.create(parent_id: parent_id, child_id: @comment.id)
        end
        flash[:success] = "Edition enregistré"
        redirect_to comment_path(@comment.id)
      else
        render 'static_pages/home'
      end
  end

  def index
    @best_comment = BestComment.find_by( reference_id: params[:reference_id] ).comment
    if !params[:sort].nil?
      if !params[:order].nil?
        @comments = Comment.order(params[:sort].to_sym => params[:order].to_sym).where(
            reference_id: params[:reference_id]).where.not(
            id: @best_comment.id).page(params[:page]).per(8)
      else
        @comments = Comment.order(params[:sort].to_sym => :desc).where(
            reference_id: params[:reference_id]).where.not(
            id: @best_comment.id).page(params[:page]).per(8)
      end
    else
      if !params[:order].nil?
        @comments = Comment.order(:score => params[:order].to_sym).where(
            reference_id: params[:reference_id]).where.not(
            id: @best_comment.id).page(params[:page]).per(8)
      else
        @comments = Comment.order(:score => :desc).page(params[:page]).where(
            reference_id: params[:reference_id]).where.not(
            id: @best_comment.id).page(params[:page]).per(8)
      end
    end
  end

  def show
    @comment = Comment.find(params[:id])
    @children = @comment.children
    @children.each do |comment|
      comment.diffy( @comment)
    end
    @parent = @comment.parent
    if @parent
      @parent.diffy( @comment)
    end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content_1, :content_2, :content_3, :content_4, :content_5, :id)
  end
end
