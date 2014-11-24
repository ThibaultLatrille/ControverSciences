class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index, :important]

  def index
    timeline_ids = NotificationTimeline.where( user_id: current_user.id, read: false ).pluck( :timeline_id )
    @timelines = Timeline.where( id: timeline_ids ).pluck( :id, :name )
    reference_ids = NotificationReference.where( user_id: current_user.id, read: false ).pluck( :reference_id )
    @references = Reference.where( id: reference_ids ).pluck( :id, :title_fr )
    comment_ids = NotificationComment.where( user_id: current_user.id, read: false ).pluck( :comment_id )
    @comments = Comment.where( id: comment_ids )
    comment_sel_ids = NotificationSelection.where( user_id: current_user.id, read: false ).pluck( :comment_id )
    @comments_sel = Comment.where( id: comment_sel_ids )
  end

  def important
    win_ids = NotificationSelectionWin.where( user_id: current_user.id, read: false ).pluck( :comment_id )
    @wins = Comment.where( id: win_ids )
    loss_ids = NotificationSelectionLoss.where( user_id: current_user.id, read: false ).pluck( :comment_id )
    @losses = Comment.where( id: loss_ids )
  end
end