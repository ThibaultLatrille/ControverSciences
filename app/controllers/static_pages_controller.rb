class StaticPagesController < ApplicationController
  def home
    @timelines = Timeline.order(:score => :desc).first(8)
  end
end
