class TimelinesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index
    if params[:sort]=='date'
    @timelines = Timeline.order(created_at: :desc).page(params[:page]).per(36)
    else
    @timelines = Timeline.order(rank: :desc).page(params[:page]).per(36)
    end
  end

  def new
    @timeline = Timeline.new
  end

  def create
    @timeline = current_user.timelines.build(timeline_params)

    names = ["life sciences", "biology"]
    @timeline.set_tag_list (names)
    puts @timeline.get_tag_list
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
