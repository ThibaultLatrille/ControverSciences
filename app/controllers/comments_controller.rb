class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @comment = Comment.new()
    @list = Reference.where( timeline_id: session[:timeline_id] ).pluck( :title, :id )
  end

  def create
    @my_comment = Comment.where({user_id: current_user.id,
          reference_id: session[:reference_id], timeline_id: session[:timeline_id],
          field: comment_params[:field]}).first
    if @my_comment
      redirect_to edit_comment_path(id: @my_comment.id, content: comment_params[:content])
    else
      @comment = Comment.new({user_id: current_user.id,
              reference_id: session[:reference_id], timeline_id: session[:timeline_id]})
      @comment.content = comment_params[:content]
      @comment.field = comment_params[:field]
      if @comment.save_with_markdown( root_url, current_user.id )
        flash[:success] = "Edition enregistré"
        redirect_to controller: 'references', action: 'show', id: session[:reference_id]
      else
        render 'static_pages/home'
      end
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    @list = Reference.where( timeline_id: session[:timeline_id] ).pluck( :title, :id )
    if params[:content]
    @comment.content = params[:content]
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.content = comment_params[:content]
      if @comment.update_markdown( root_url, current_user.id )
        flash[:success] = "Commentaire modifié"
        redirect_to @comment.reference
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  def index
    if !params[:sort].nil?
      if !params[:order].nil?
        @comments = Comment.order(params[:sort].to_sym => params[:order].to_sym).where({field: params[:field],
                                reference_id: params[:reference_id]}).page(params[:page]).per(8)
      else
        @comments = Comment.order(params[:sort].to_sym => :desc).where({field: params[:field],
                                reference_id: params[:reference_id]}).page(params[:page]).per(8)
      end
    else
      if !params[:order].nil?
        @comments = Comment.order(:score => params[:order].to_sym).where({field: params[:field],
                                reference_id: params[:reference_id]}).page(params[:page]).per(8)
      else
        @comments = Comment.order(:score => :desc).page(params[:page]).where({field: params[:field],
                                reference_id: params[:reference_id]}).per(8)
      end
    end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content,:field)
  end
end
