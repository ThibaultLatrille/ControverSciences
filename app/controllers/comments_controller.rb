class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    comment = Comment.find_by(user_id: current_user.id, reference_id: params[:reference_id])
    if comment
      redirect_to edit_comment_path(id: comment.id)
    else
      @comment = Comment.new
      @myreference = Reference.find(params[:reference_id]) rescue nil
      if @myreference.blank?
        flash[:danger] = "Cette référence n'existe pas (ou plus) !"
        redirect_to timelines_path
      else
        @comment.reference_id = @myreference.id
        @comment.timeline_id = @myreference.timeline_id
        @list = Reference.order(year: :desc).where(timeline_id: @comment.timeline_id).pluck(:title, :id, :author, :year)
        @tim_list = timelines_connected_to(@comment.timeline_id)
      end
    end
  end

  def create
    @comment = Comment.new(comment_params)
    if comment_params[:has_picture] == 'true' && comment_params[:delete_picture] == 'false'
      @comment.figure_id = Figure.order(:created_at).where(user_id: current_user.id,
                                                           reference_id: @comment.reference_id).last.id
      @comment.caption = comment_params[:caption]
    end
    @comment.user_id = current_user.id
    if @comment.is_same_as_best
      flash[:info] = t('controllers.same_parts')
    end
    if @comment.save_with_markdown
      flash[:success] = t('controllers.comment_saved')
      redirect_to @comment
    else
      @myreference = Reference.find(@comment.reference_id)
      @list = Reference.order(year: :desc).where(timeline_id: comment_params[:timeline_id])
                  .pluck(:title, :id, :author, :year)
      @tim_list = timelines_connected_to(comment_params[:timeline_id])
      render 'new'
    end
  end

  def edit
    if GoPatch.where(comment_id: params[:id]).count > 0
      flash[:danger] = t('controllers.patches_pending')
      redirect_to patches_target_path(comment_id: params[:id])
    else
      @comment = Comment.find(params[:id])
      @myreference = Reference.find(@comment.reference_id)
      @list = Reference.order(year: :desc).where(timeline_id: @comment.timeline_id)
                  .pluck(:title, :id, :author, :year)
      @tim_list = timelines_connected_to(@comment.timeline_id)
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id || current_user.admin
      if GoPatch.where(comment_id: params[:id]).count > 0
        flash[:danger] = t('controllers.patches_pending')
        redirect_to patches_target_path(comment_id: params[:id])
      else
        @comment.public = comment_params[:public]
        for fi in 0..5 do
          @comment["f_#{fi}_content".to_sym] = comment_params["f_#{fi}_content".to_sym]
        end
        @comment.title = comment_params[:title]
        @comment.caption = comment_params[:caption]
        if comment_params[:delete_picture] == 'true'
          @comment.figure_id = nil
        elsif comment_params[:has_picture] == 'true'
          @comment.figure_id = Figure.order(:created_at).where(user_id: @comment.user_id,
                                                               reference_id: @comment.reference_id).last.id
        end
        if @comment.update_with_markdown
          flash[:success] = t('controllers.comment_updated')
          redirect_to reference_path(@comment.reference_id, filter: :mine)
        else
          @myreference = Reference.find(@comment.reference_id)
          @list = Reference.order(year: :desc).where(timeline_id: @comment.timeline_id)
                      .pluck(:title, :id, :author, :year)
          @tim_list = timelines_connected_to(@comment.timeline_id)
          render 'edit'
        end
      end
    else
      redirect_to @comment
    end
  end

  def show
    begin
      @comment = Comment.find(params[:id])
      @timeline = Timeline.select(:id, :slug, :private).find(@comment.timeline_id)
      if @timeline.private && !logged_in?
        flash[:danger] = "Cette analyse appartient à une controverse privée, vous ne pouvez pas y accèder !"
        redirect_to timelines_path
      else
        unless @comment.public
          if current_user && current_user.id == @comment.user_id
            flash.now[:info] = t('controllers.comment_private')
          else
            flash[:danger] = t('controllers.comment_privated')
            redirect_to reference_path(@comment.reference_id)
          end
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = t('controllers.comment_record_not_found')
      redirect_to timelines_path
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user_id == current_user.id || current_user.admin
      comment.destroy_with_counters
      redirect_to reference_path(comment.reference_id)
    else
      flash[:danger] = t('controllers.comment_cannot_delete')
      redirect_to comment_path(params[:id])
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:id, :reference_id, :timeline_id, :f_0_content, :f_1_content, :f_2_content,
                                    :f_3_content, :f_4_content, :f_5_content, :public, :has_picture, :caption, :delete_picture, :title)
  end
end
