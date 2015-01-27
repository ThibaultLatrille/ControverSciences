class TimelinesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def index
    if params[:tag] != 'all' && !params[:tag].nil?
      if !params[:sort].nil?
        if !params[:order].nil?
          @timelines = Timeline.tagged_with(params[:tag]).order(params[:sort].to_sym => params[:order].to_sym).page(params[:page]).per(16)
        else
          @timelines = Timeline.tagged_with(params[:tag]).order(params[:sort].to_sym => :desc).page(params[:page]).per(16)
        end
      else
        if !params[:order].nil?
          @timelines = Timeline.tagged_with(params[:tag]).order(:score => params[:order].to_sym).page(params[:page]).per(16)
        else
          @timelines = Timeline.tagged_with(params[:tag]).order(:score => :desc).page(params[:page]).per(16)
        end
      end
    else
      if !params[:sort].nil?
        if !params[:order].nil?
          @timelines = Timeline.order(params[:sort].to_sym => params[:order].to_sym).page(params[:page]).per(16)
        else
          @timelines = Timeline.order(params[:sort].to_sym => :desc).page(params[:page]).per(16)
        end
      else
        if !params[:order].nil?
          @timelines = Timeline.order(:score => params[:order].to_sym).page(params[:page]).per(16)
        else
          @timelines = Timeline.order(:score => :desc).page(params[:page]).per(16)
        end
      end
    end
  end

  def new
    @timeline = Timeline.new
  end

  def create
    @timeline = Timeline.new( user_id: current_user.id, name: timeline_params[:name])
    if params[:timeline][:tag_list]
      @timeline.set_tag_list(params[:timeline][:tag_list][0..6])
    end
    if @timeline.save
      flash[:success] = "Timeline créer"
      redirect_to @timeline
    else
      render 'new'
    end
  end

  def show
    @timeline = Timeline.find(params[:id])
    summary_best = SummaryBest.find_by(timeline_id: params[:id])
    if summary_best
      @summary = Summary.find( summary_best.summary_id )
    else
      @summary = nil
    end
    @references = Reference.select( :id, :title_fr, :year).order( year: :desc).where( timeline_id: @timeline.id )
  end

  def destroy
    timeline = Timeline.find(params[:id])
    if timeline.user_id == current_user.id
      timeline.destroy
      redirect_to my_items_timelines_path
    end
  end

  private

  def timeline_params
    params.require(:timeline).permit(:name, :timeline_edit_content)
  end
end
