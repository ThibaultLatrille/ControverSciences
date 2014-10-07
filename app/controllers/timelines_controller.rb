class TimelinesController < ApplicationController

  def index
    @timelines = Timeline.order(rank: :desc).page(params[:page]).per(36)
  end

  def new
    @timeline = Timeline.new
  end

  def show
    @timeline = Timeline.find(params[:id])
  end

  def edit
    @timeline = Timeline.find(params[:id])
  end
end
