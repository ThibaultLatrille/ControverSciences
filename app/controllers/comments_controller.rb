class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @comment = Comment.new()
    if params[:comment_id]
      @parent = Comment.find(params[:comment_id])
      session[:reference_id] = @parent.reference_id
      session[:timeline_id] = @parent.timeline_id
      @comment.content = @parent.content
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
      @comment.content = comment_params[:content]
      @comment.field = comment_params[:field]
      parent_id = comment_params[:id]
      if @comment.save_with_markdown( root_url, current_user.id )
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
    @best_comment = BestComment.find_by( field: params[:field],
                                        reference_id: params[:reference_id] ).comment
    if !params[:sort].nil?
      if !params[:order].nil?
        @comments = Comment.order(params[:sort].to_sym => params[:order].to_sym).where(
            field: params[:field], reference_id: params[:reference_id]).where.not(
            id: @best_comment.id).page(params[:page]).per(8)
      else
        @comments = Comment.order(params[:sort].to_sym => :desc).where(
            field: params[:field], reference_id: params[:reference_id]).where.not(
            id: @best_comment.id).page(params[:page]).per(8)
      end
    else
      if !params[:order].nil?
        @comments = Comment.order(:score => params[:order].to_sym).where(
            field: params[:field], reference_id: params[:reference_id]).where.not(
            id: @best_comment.id).page(params[:page]).per(8)
      else
        @comments = Comment.order(:score => :desc).page(params[:page]).where(
            field: params[:field], reference_id: params[:reference_id]).where.not(
            id: @best_comment.id).page(params[:page]).per(8)
      end
    end
  end

  def show
    @comment = Comment.find(params[:id])
    @best_comment = BestComment.find_by( field: @comment.field,
                                         reference_id: @comment.reference_id ).comment
    @best_comment.diff = Diffy::Diff.new(@comment.content, @best_comment.content,
                                         :include_plus_and_minus_in_html => true).to_s(:html)
    @children = @comment.children
    @children.each do |comment|
      comment.diff = Diffy::Diff.new(@comment.content, comment.content,
                              :include_plus_and_minus_in_html => true).to_s(:html)
    end
    @parent = @comment.parent
    if @parent
      @parent.diff = Diffy::Diff.new(@comment.content, @parent.content,
                                     :include_plus_and_minus_in_html => true).to_s(:html)
    end
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content,:field, :id)
  end
end
