class TimelinesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index
    if !params[:tag].nil?
      if params[:tag] != 'all'
        if !params[:sort].nil?
          if !params[:order].nil?
            @timelines = Timeline.tagged_with(params[:tag]).order(params[:sort].to_sym => params[:order].to_sym).page(params[:page]).per(8)
          else
            @timelines = Timeline.tagged_with(params[:tag]).order(params[:sort].to_sym => :desc).page(params[:page]).per(8)
          end
        else
          if !params[:order].nil?
            @timelines = Timeline.tagged_with(params[:tag]).order(:rank => params[:order].to_sym).page(params[:page]).per(8)
          else
            @timelines = Timeline.tagged_with(params[:tag]).order(:rank => :desc).page(params[:page]).per(8)
          end
        end
      else
        if !params[:sort].nil?
          if !params[:order].nil?
            @timelines = Timeline.order(params[:sort].to_sym => params[:order].to_sym).page(params[:page]).per(8)
          else
            @timelines = Timeline.order(params[:sort].to_sym => :desc).page(params[:page]).per(8)
          end
        else
          if !params[:order].nil?
            @timelines = Timeline.order(:rank => params[:order].to_sym).page(params[:page]).per(8)
          else
            @timelines = Timeline.order(:rank => :desc).page(params[:page]).per(8)
          end
        end
      end
    else
      @timelines = Timeline.order(rank: :desc).page(params[:page]).per(8)
    end
  end

  def new
    @timeline = Timeline.new
  end

  def create
    @timeline = Timeline.new( user_id: current_user.id, name: timeline_params[:name],
                      timeline_edit_content: timeline_params[:timeline_edit_content])
    @timeline.set_tag_list(params[:timeline][:tag_list][0..6])
    if @timeline.save
      flash[:success] = "Timeline créer"
      redirect_to @timeline
    else
      render 'static_pages/home'
    end
  end

  def show
    @timeline = Timeline.find(params[:id])
    session[:timeline_id] = @timeline.id
    session[:timeline_name] = @timeline.name
  end

  private

  def timeline_params
    params.require(:timeline).permit(:name, :timeline_edit_content)
  end
end
