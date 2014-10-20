class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]

  def create
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

  def edit
    @comment = Comment.find(params[:id])
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
    @comments = Comment.order(rank: :desc).where({field: params[:field], reference_id: params[:reference_id]}).page(params[:page]).per(5)
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content,:field)
  end
end
