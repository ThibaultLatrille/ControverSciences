class SummariesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    summary = Summary.find_by(user_id: current_user.id, timeline_id: params[:timeline_id])
    if summary
      redirect_to edit_summary_path(id: summary.id)
    else
      @summary             = Summary.new
      @summary.timeline_id = params[:timeline_id]
      @my_timeline         = Timeline.select(:id, :slug, :nb_summaries, :name).find(@summary.timeline_id)
      @list                = Reference.order(year: :desc).where(timeline_id: @summary.timeline_id).pluck(:title, :id)
      @tim_list            = Timeline.where(id: Edge.where(timeline_id:
                                                               @summary.timeline_id).pluck(:target)).pluck(:name, :id)
    end
  end

  def create
    @summary = Summary.new(timeline_id: summary_params[:timeline_id],
                           content:     summary_params[:content],
                           public:      summary_params[:public])
    if summary_params[:has_picture] == 'true' && summary_params[:delete_picture] == 'false'
      @summary.figure_id = Figure.order(:created_at).where(user_id:     current_user.id,
                                                           timeline_id: @summary.timeline_id).last.id
      @summary.caption   = summary_params[:caption]
    end
    @summary.user_id = current_user.id
    if @summary.save_with_markdown
      flash[:success] = "Synthèse enregistrée."
      redirect_to summaries_path(filter: "mine", timeline_id: @summary.timeline_id)
    else
      @list        = Reference.order(year: :desc).where(timeline_id: summary_params[:timeline_id]).pluck(:title, :id)
      @tim_list    = Timeline.where(id: Edge.where(timeline_id:
                                                       summary_params[:timeline_id]).pluck(:target)).pluck(:name, :id)
      @my_timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find(@summary.timeline_id)
      render 'new'
    end
  end

  def edit
    @summary     = Summary.find(params[:id])
    @my_timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find(@summary.timeline_id)
    @list        = Reference.order(year: :desc).where(timeline_id: @summary.timeline_id).pluck(:title, :id)
    @tim_list    = Timeline.where(id: Edge.where(timeline_id:
                                                     @summary.timeline_id).pluck(:target)).pluck(:name, :id)
  end

  def update
    @summary    = Summary.find(params[:id])
    @my_summary = Summary.find(params[:id])
    if @summary.user_id == current_user.id || current_user.admin
      @summary.content = summary_params[:content]
      @summary.public  = summary_params[:public]
      @summary.caption = summary_params[:caption]
      if summary_params[:delete_picture] == 'true'
        @summary.figure_id = nil
      elsif summary_params[:has_picture] == 'true'
        @summary.figure_id = Figure.order(:created_at).where(user_id:     @summary.user_id,
                                                             timeline_id: @summary.timeline_id).last.id
      end
      if @summary.update_with_markdown
        flash[:success] = "Synthèse modifiée."
        redirect_to @summary
      else
        @my_timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find(@summary.timeline_id)
        @list        = Reference.order(year: :desc).where(timeline_id: @summary.timeline_id).pluck(:title, :id)
        @tim_list    = Timeline.where(id: Edge.where(timeline_id:
                                                         @summary.timeline_id).pluck(:target)).pluck(:name, :id)
        render 'edit'
      end
    else
      redirect_to @summary
    end
  end

  def show
    @summary = Summary.select(:id, :user_id, :timeline_id,
                              :markdown, :balance, :best, :figure_id, :caption_markdown,
                              :created_at).find(params[:id])
    if logged_in?
      @improve   = Summary.where(user_id: current_user.id, timeline_id: @summary.timeline_id).count == 1 ? false : true
      @my_credit = Credit.find_by(user_id: current_user.id, timeline_id: params[:timeline_id])
    end
    @timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find(@summary.timeline_id)
  end

  def index
    @timeline = Timeline.select(:id, :slug, :nb_summaries, :name).find(params[:timeline_id])
    if logged_in?
      user_id = current_user.id
      visit   = VisiteTimeline.find_by(user_id: user_id, timeline_id: params[:timeline_id])
      if visit
        visit.update(updated_at: Time.zone.now)
      else
        VisiteTimeline.create(user_id: user_id, timeline_id: params[:timeline_id])
      end
      @improve   = Summary.where(user_id: user_id, timeline_id: params[:timeline_id]).count == 1 ? false : true
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
      flash[:danger] = "Cette synthèse est la meilleure et ne peut être supprimée."
      redirect_to summary_path(params[:id])
    end
  end

  private

  def summary_params
    params.require(:summary).permit(:timeline_id, :content, :public, :picture, :caption, :delete_picture, :has_picture)
  end
end
