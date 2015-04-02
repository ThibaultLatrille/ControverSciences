class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index, :important, :delete, :delete_all, :summary,
                       :summary_selection, :selection, :timeline, :reference, :comment,
                       :selection_win, :summary_selection_win, :selection_loss, :summary_selection_loss]

  def index
    if params[:filter]
      @filter = params[:filter].to_sym
    else
      if current_user.notifications_timeline > 0
        @filter = :timeline
      else
        if current_user.notifications_reference > 0
          @filter = :reference
        else
          if current_user.notifications_comment > 0
            @filter = :comment
          else
            if current_user.notifications_selection > 0
              @filter = :selection
            else
              @filter = :timeline
            end
          end
        end
      end
    end
    @notification = Notification.new
    case @filter
      when :timeline
        timeline_ids = NotificationTimeline.where( user_id: current_user.id).pluck( :timeline_id )
        @timelines = Timeline.select(:id, :name).where( id: timeline_ids ).page(params[:page]).per(20)
      when :summary
        summary_ids = NotificationSummary.where( user_id: current_user.id ).pluck( :summary_id )
        @summaries = Summary.select(:id, :timeline_id,
                                    :content).where( id: summary_ids ).page(params[:page]).per(20)
      when :reference
        reference_ids = NotificationReference.where( user_id: current_user.id).pluck( :reference_id )
        @references = Reference.select(:id, :timeline_id, :title).where( id: reference_ids ).page(params[:page]).per(20)
      when :comment
        comment_ids = NotificationComment.where( user_id: current_user.id ).pluck( :comment_id )
        @comments = Comment.select(:id, :timeline_id, :reference_id,
                               :title_markdown).where( id: comment_ids ).page(params[:page]).per(20)
      when :selection
        comment_sel_ids = NotificationSelection.where( user_id: current_user.id).pluck( :new_comment_id )
        @selections = Comment.select(:id, :timeline_id, :reference_id,
                                     :title_markdown).where( id: comment_sel_ids ).page(params[:page]).per(20)
      when :summary_selection
        summary_sel_ids = NotificationSummarySelection.where( user_id: current_user.id).pluck( :new_summary_id )
        @summary_selections = Summary.select(:id, :timeline_id,
                                     :content).where( id: summary_sel_ids ).page(params[:page]).per(20)
    end
  end

  def important
    win_ids = NotificationSelectionWin.where( user_id: current_user.id ).pluck( :comment_id )
    @wins = Comment.select(:id, :timeline_id, :reference_id,
                           :title_markdown).where( id: win_ids )
    loss_ids = NotificationSelectionLoss.where( user_id: current_user.id ).pluck( :comment_id )
    @losses = Comment.select(:id, :timeline_id, :reference_id,
                             :title_markdown).where( id: loss_ids )
    summary_win_ids = NotificationSummarySelectionWin.where( user_id: current_user.id ).pluck( :summary_id )
    @summary_wins = Summary.select(:id, :timeline_id,
                           :content).where( id: summary_win_ids )
    summary_loss_ids = NotificationSummarySelectionLoss.where( user_id: current_user.id ).pluck( :summary_id )
    @summary_losses = Summary.select(:id, :timeline_id,
                           :content).where( id: summary_loss_ids )
  end

  def delete
    if params[:notification]
      if params[:notification][:timeline_ids]
        notifs = NotificationTimeline.where( user_id: current_user.id,
                              timeline_id: params[:notification][:timeline_ids] )
        notifs.destroy_all
        redirect_to notifications_index_path( filter: :timeline)
        return
      end
      if params[:notification][:summary_ids]
        notifs = NotificationSummary.where( user_id: current_user.id,
                                            summary_id: params[:notification][:summary_ids] )
        notifs.destroy_all
        redirect_to notifications_index_path( filter: :summary)
        return
      end
      if params[:notification][:reference_ids]
        notifs = NotificationReference.where( user_id: current_user.id,
                              reference_id: params[:notification][:reference_ids] )
        notifs.destroy_all
        redirect_to notifications_index_path( filter: :reference)
        return
      end
      if params[:notification][:comment_ids]
        notifs = NotificationComment.where( user_id: current_user.id,
                              comment_id: params[:notification][:comment_ids] )
        notifs.destroy_all
        redirect_to notifications_index_path( filter: :comment)
        return
      end
      if params[:notification][:sel_comment_ids]
        notifs = NotificationSelection.where( user_id: current_user.id,
                              new_comment_id: params[:notification][:sel_comment_ids] )
        notifs.destroy_all
        redirect_to notifications_index_path( filter: :selection)
        return
      end
      if params[:notification][:sel_summary_ids]
        notifs = NotificationSummarySelection.where( user_id: current_user.id,
                                              new_summary_id: params[:notification][:sel_summary_ids] )
        notifs.destroy_all
        redirect_to notifications_index_path( filter: :summary_selection)
        return
      end
    end
    redirect_to notifications_index_path
  end

  def delete_all
    case params[:filter]
      when :timeline.to_s
        notifs = NotificationTimeline.where( user_id: current_user.id )
        notifs.destroy_all
      when :summary.to_s
        notifs = NotificationSummary.where( user_id: current_user.id )
        notifs.destroy_all
      when :reference.to_s
        notifs = NotificationReference.where( user_id: current_user.id )
        notifs.destroy_all
      when :comment.to_s
        notifs = NotificationComment.where( user_id: current_user.id )
        notifs.destroy_all
      when :selection.to_s
        notifs = NotificationSelection.where( user_id: current_user.id )
        notifs.destroy_all
      when :summary_selection.to_s
        notifs = NotificationSummarySelection.where( user_id: current_user.id )
        notifs.destroy_all
    end
    redirect_to notifications_index_path
  end

  def timeline
    notif = NotificationTimeline.find_by( user_id: current_user.id,
                        timeline_id: notification_params )
    notif.destroy
    redirect_to timeline_path( notification_params )
  end

  def summary
    notif = NotificationSummary.find_by( user_id: current_user.id,
                                           summary_id: notification_params )
    notif.destroy
    redirect_to summary_path( notification_params )
  end

  def reference
    notif = NotificationReference.find_by( user_id: current_user.id,
                                          reference_id: notification_params )
    notif.destroy
    redirect_to reference_path( notification_params )
  end

  def comment
    notif = NotificationComment.find_by( user_id: current_user.id,
                                          comment_id: notification_params )
    notif.destroy
    redirect_to comment_path( notification_params )
  end

  def selection
    notif = NotificationSelection.find_by( user_id: current_user.id,
                                          new_comment_id: notification_params )
    notif.destroy
    redirect_to comment_path( notification_params )
  end

  def summary_selection
    notif = NotificationSummarySelection.find_by( user_id: current_user.id,
                                           new_summary_id: notification_params )
    notif.destroy
    redirect_to summary_path( notification_params )
  end

  def selection_win
    notif = NotificationSelectionWin.find_by( user_id: current_user.id,
                                           comment_id: notification_params )
    notif.destroy
    redirect_to comment_path( notification_params )
  end

  def summary_selection_win
    notif = NotificationSummarySelectionWin.find_by( user_id: current_user.id,
                                                  summary_id: notification_params )
    notif.destroy
    redirect_to summary_path( notification_params )
  end

  def selection_loss
    notif = NotificationSelectionLoss.find_by( user_id: current_user.id,
                                              comment_id: notification_params )
    notif.destroy
    redirect_to comment_path( notification_params )
  end

  def summary_selection_loss
    notif = NotificationSummarySelectionLoss.find_by( user_id: current_user.id,
                                                     summary_id: notification_params )
    notif.destroy
    redirect_to summary_path( notification_params )
  end

  private

  def notification_params
    params.permit( :id, :field )
  end

end