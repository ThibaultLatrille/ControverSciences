class SummariesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    summary = Summary.find_by(user_id: current_user.id, timeline_id: params[:timeline_id])
    if summary
      redirect_to edit_summary_path(id: summary.id)
    else
      @summary = Summary.new
      @summary.timeline_id = params[:timeline_id]
      @my_timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find(@summary.timeline_id)
      @list = Reference.order(year: :desc).where(timeline_id: @summary.timeline_id)
                  .pluck(:title, :id, :author, :year)
      @tim_list = timelines_connected_to(@summary.timeline_id)
    end
  end

  def create
    @summary = Summary.new(timeline_id: summary_params[:timeline_id],
                           content: summary_params[:content],
                           public: summary_params[:public])
    if summary_params[:has_picture] == 'true' && summary_params[:delete_picture] == 'false'
      @summary.figure_id = Figure.order(:created_at).where(user_id: current_user.id,
                                                           timeline_id: @summary.timeline_id).last.id
      @summary.caption = summary_params[:caption]
    end
    @summary.user_id = current_user.id
    if @summary.save_with_markdown
      flash[:success] = t('controllers.summary_added')
      redirect_to @summary
    else
      @list = Reference.order(year: :desc).where(timeline_id: summary_params[:timeline_id])
                  .pluck(:title, :id, :author, :year)
      @tim_list = timelines_connected_to(summary_params[:timeline_id])
      @my_timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find(@summary.timeline_id)
      render 'new'
    end
  end

  def edit
    if GoPatch.where(summary_id: params[:id]).count > 0
      flash[:danger] = t('controllers.patches_pending')
      redirect_to patches_target_path(summary_id: params[:id])
    else
      @summary = Summary.find(params[:id])
      @my_timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find(@summary.timeline_id)
      @list = Reference.order(year: :desc).where(timeline_id: @summary.timeline_id)
                  .pluck(:title, :id, :author, :year)
      @tim_list = timelines_connected_to(@summary.timeline_id)
    end
  end

  def update
    @summary = Summary.find(params[:id])
    @my_summary = Summary.find(params[:id])
    if @summary.user_id == current_user.id || current_user.admin
      if GoPatch.where(summary_id: params[:id]).count > 0
        flash[:danger] = t('controllers.patches_pending')
        redirect_to patches_target_path(summary_id: params[:id])
      else
        @summary.content = summary_params[:content]
        @summary.public = summary_params[:public]
        @summary.caption = summary_params[:caption]
        if summary_params[:delete_picture] == 'true'
          @summary.figure_id = nil
        elsif summary_params[:has_picture] == 'true'
          @summary.figure_id = Figure.order(:created_at).where(user_id: @summary.user_id,
                                                               timeline_id: @summary.timeline_id).last.id
        end
        if @summary.update_with_markdown
          flash[:success] = t('controllers.summary_updated')
          redirect_to @summary
        else
          @my_timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find(@summary.timeline_id)
          @list = Reference.order(year: :desc).where(timeline_id: @summary.timeline_id)
                      .pluck(:title, :id, :author, :year)
          @tim_list = timelines_connected_to(@summary.timeline_id)
          render 'edit'
        end
      end
    else
      redirect_to @summary
    end
  end

  def show
    begin
      @summary = Summary.find(params[:id])
      @timeline = Timeline.find(@summary.timeline_id)
      if @timeline.private && !logged_in?
        flash[:danger] = "Cette synthèse appartient à une controverse privée, vous ne pouvez pas y accèder !"
        redirect_to_back timelines_path
      else
        if logged_in?
          @improve = Summary.where(user_id: current_user.id, timeline_id: @summary.timeline_id).count == 1 ? false : true
          @my_credit = Credit.find_by(user_id: current_user.id, timeline_id: @summary.timeline_id)
          @only_one_summary = Summary.where(public: true, timeline_id: @summary.timeline_id).count == 1
        end
      end
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = t('controllers.summary_record_not_found')
      redirect_to timelines_path
    end
  end

  def index
    @timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find_by(id: params[:timeline_id])
    if @timeline.nil?
      flash[:danger] = t('controllers.timeline_record_not_found')
      redirect_to timelines_path
      return
    end
    if logged_in?
      user_id = current_user.id
      @timeline.update_visite_by_user(user_id)
      @improve = Summary.where(user_id: user_id, timeline_id: params[:timeline_id]).count == 1 ? false : true
      @my_credit = Credit.find_by(user_id: user_id, timeline_id: params[:timeline_id])
      if params[:filter] == "mine"
        @summaries = Summary.where(user_id: user_id, timeline_id: params[:timeline_id])
      elsif params[:filter] == "my-vote" && @my_credit
        @summaries = Summary.where(id: @my_credit.summary_id)
      else
        @summaries = Summary.where(timeline_id: params[:timeline_id], public: true)
      end
    else
      query = Summary.where(
          timeline_id: params[:timeline_id], public: true)
      if params[:sort].nil?
        if params[:order].nil?
          query = query.order(:score => :desc)
        else
          query = query.order(:score => params[:order].to_sym)
        end
      else
        if params[:order].nil?
          query = query.order(params[:sort].to_sym => :desc)
        else
          query = query.order(params[:sort].to_sym => params[:order].to_sym)
        end
      end
      @summaries = query
    end
  end

  def destroy
    summary = Summary.find(params[:id])
    if summary.user_id == current_user.id || current_user.admin
      summary.destroy_with_counters
      redirect_to timeline_path(summary.timeline_id)
    else
      flash[:danger] = t('controllers.summary_cannot_delete')
      redirect_to summary_path(params[:id])
    end
  end

  private

  def summary_params
    params.require(:summary).permit(:timeline_id, :content, :public, :picture, :caption, :delete_picture, :has_picture)
  end
end
