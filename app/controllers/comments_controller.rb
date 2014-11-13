class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @comment = Comment.new()
    @list = Reference.where( timeline_id: session[:timeline_id] ).pluck( :title_fr, :id )
  end

  def create
    @my_comment = Comment.where({user_id: current_user.id, reference_id: session[:reference_id], field: comment_params[:field]}).first
    if @my_comment
      redirect_to edit_comment_path(id: @my_comment.id, content: comment_params[:content])
    else
      @comment = Comment.new({user_id: current_user.id, reference_id: session[:reference_id], timeline_id: session[:timeline_id]})
      @comment.content = comment_params[:content]
      @comment.field = comment_params[:field]
      if @comment.save
        #if not already one comment from current user
        flash[:success] = "Edition enregistré"
        redirect_to controller: 'references', action: 'show', id: session[:reference_id]
      else
        render 'static_pages/home'
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @content = @comment.content
    if params[:content]
    @comment.content = params[:content]
    end
  end


  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params) && @comment.user_id == current_user.id
      flash[:success] = "Commentaire modifié"
      redirect_to @comment.reference
    else
      render 'edit'
    end
  end

  def index
    @comments = Comment.order(rank: :desc).where({field: params[:field], reference_id: params[:reference_id]}).page(params[:page]).per(20)
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content,:field)
  end
end
