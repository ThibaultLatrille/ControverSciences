class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index, :important, :delete, :timeline]

  def index
    @notification = Notification.new
    timeline_ids = NotificationTimeline.where( user_id: current_user.id, read: false ).pluck( :timeline_id )
    @timelines = Timeline.select(:id, :name).where( id: timeline_ids )
    reference_ids = NotificationReference.where( user_id: current_user.id, read: false ).pluck( :reference_id )
    @references = Reference.select(:id, :timeline_id, :title_fr).where( id: reference_ids )
    comment_ids = NotificationComment.where( user_id: current_user.id, read: false ).pluck( :comment_id )
    @comments = Comment.select(:id, :timeline_id, :reference_id,
                               :f_1_content).where( id: comment_ids )
    comment_sel_ids = NotificationSelection.where( user_id: current_user.id, read: false ).pluck( :comment_id )
    @comments_sel = Comment.select(:id, :comment_id, :timeline_id, :reference_id,
                                   :value).where( id: comment_sel_ids )
  end

  def important
    win_ids = NotificationSelectionWin.where( user_id: current_user.id, read: false ).pluck( :comment_id )
    @wins = Comment.where( id: win_ids )
    loss_ids = NotificationSelectionLoss.where( user_id: current_user.id, read: false ).pluck( :comment_id )
    @losses = Comment.where( id: loss_ids )
  end

  def delete
    if params[:notification][:timeline_ids]
      notifs = NotificationTimeline.where( user_id: current_user.id,
                            timeline_id: params[:notification][:timeline_ids] )
      User.update_counters( current_user.id, notifications_timeline: -notifs.length )
      notifs.destroy_all
    end
    if params[:notification][:reference_ids]
      notifs = NotificationReference.where( user_id: current_user.id,
                            reference_id: params[:notification][:reference_ids] )
      User.update_counters( current_user.id, notifications_reference: -notifs.length )
      notifs.destroy_all
    end
    if params[:notification][:comment_ids]
      notifs = NotificationComment.where( user_id: current_user.id,
                            comment_id: params[:notification][:comment_ids] )
      User.update_counters( current_user.id, notifications_comment: -notifs.length )
      notifs.destroy_all
    end
    if params[:notification][:sel_comment_ids]
      notifs = NotificationSelection.where( user_id: current_user.id,
                            comment_id: params[:notification][:sel_comment_ids] )
      User.update_counters( current_user.id, notifications_selection: -notifs.length )
      notifs.destroy_all
    end
    redirect_to notifications_index_path
  end

  def timeline
    notif = NotificationTimeline.find_by( user_id: current_user.id,
                        timeline_id: notification_params )
    User.update_counters( current_user.id, notifications_timeline: -1 )
    notif.destroy
    redirect_to timeline_path( notification_params )
  end

  def reference
    notif = NotificationReference.find_by( user_id: current_user.id,
                                          reference_id: notification_params )
    User.update_counters( current_user.id, notifications_reference: -1 )
    notif.destroy
    redirect_to reference_path( notification_params )
  end

  def comment
    notif = NotificationComment.find_by( user_id: current_user.id,
                                          comment_id: notification_params )
    User.update_counters( current_user.id, notifications_comment: -1 )
    notif.destroy
    redirect_to comment_path( notification_params )
  end

  def selection
    notif = NotificationSelection.find_by( user_id: current_user.id,
                                          comment_id: notification_params )
    User.update_counters( current_user.id, notifications_selection: -1 )
    notif.destroy
    redirect_to comment_path( notification_params )
  end

  private

  def notification_params
    params.require( :id )
  end

end