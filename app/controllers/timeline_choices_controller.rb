class TimelineChoicesController < ApplicationController

  def create
    TimelineChoice.create(user_id: logged_in? ? current_user.id : nil,
                       timeline_id: params[:timeline_id],
                       choices: params[:choices])
    redirect_to timeline_path(params[:friendly_id])
  end
end
