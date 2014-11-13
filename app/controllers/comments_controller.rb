class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @comment = Comment.new()
    @list = Reference.where( timeline_id: session[:timeline_id] ).pluck( :title_fr, :id )
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
      links = @comment.markdown
      if @comment.save
        reference_ids = Reference.where(timeline_id: @comment.timeline_id).pluck(:id)
        links.each do |link|
          if reference_ids.include? link
            Link.create({comment_id: @comment.id, user_id: current_user.id,
                         reference_id: link, timeline_id: @comment.timeline_id})
            puts Link.last.inspect
          end
        end
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
    if @comment.user_id == current_user.id
      @comment.content = comment_params[:content]
      links = @comment.markdown
      if Comment.update(@comment.id, content: @comment.content,
            content_markdown: @comment.content_markdown)
        Link.where(user_id: current_user.id, comment_id: @comment.id).destroy_all
        reference_ids = Reference.where(timeline_id: @comment.timeline_id).pluck(:id)
        links.each do |link|
          if reference_ids.include? link
            Link.create({comment_id: @comment.id, user_id: current_user.id,
                         reference_id: link, timeline_id: @comment.timeline_id})
            puts Link.last.inspect
          end
        end
        flash[:success] = "Commentaire modifié"
        puts links
        redirect_to @comment.reference
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end

  def index
    @comments = Comment.order(rank: :desc).where({field: params[:field],
                      reference_id: params[:reference_id]}).page(params[:page]).per(20)
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content,:field)
  end
end
