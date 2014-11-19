class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    timeline_ids = NotificationTimeline.where( user_id: current_user.id, read: false ).pluck( :timeline_id )
    @timelines = Timeline.where( id: timeline_ids ).pluck( :id, :name )
    reference_ids = NotificationReference.where( user_id: current_user.id, read: false ).pluck( :reference_id )
    @references = Reference.where( id: reference_ids ).pluck( :id, :title_fr )
    comment_ids = NotificationComment.where( user_id: current_user.id, read: false ).pluck( :comment_id )
    @comments = Comment.where( id: comment_ids )
  end
end