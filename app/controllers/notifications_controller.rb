class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index, :important, :delete, :delete_all, :delete_all_important, :summary,
                                        :summary_selection, :selection, :timeline, :reference, :comment, :suggestions,
                                        :selection_win, :summary_selection_win, :selection_loss, :summary_selection_loss, :suggestion]

  def index
    if params[:filter]
      @filter = params[:filter].to_sym
    else
      if Notification.where(user_id: current_user.id, category: 1).count > 0
        @filter = :timeline
      else
        if Notification.where(user_id: current_user.id, category: 2).count > 0
          @filter = :reference
        else
          if Notification.where(user_id: current_user.id, category: 3).count > 0
            @filter = :summary
          else
            if Notification.where(user_id: current_user.id, category: 5).count > 0
              @filter = :comment
            else
              if Notification.where(user_id: current_user.id, category: 4).count > 0
                @filter = :summary_selection
              else
                if Notification.where(user_id: current_user.id, category: 6).count > 0
                  @filter = :selection
                else
                  if Notification.where(user_id: current_user.id, category: 7).count > 0
                    @filter = :suggestions
                  else
                    @filter = :timeline
                  end
                end
              end
            end
          end
        end
      end
    end
    @notification = Notification.new
    case @filter
      when :timeline
        timeline_ids = Notification.where(user_id: current_user.id, category: 1).pluck(:timeline_id)
        @timelines   = Timeline.select(:id, :name,
                                       :user_id).where(id: timeline_ids).page(params[:page]).per(20)
      when :reference
        reference_ids = Notification.where(user_id: current_user.id, category: 2).pluck(:reference_id)
        @references   = Reference.select(:id, :timeline_id, :title,
                                         :user_id).where(id: reference_ids).page(params[:page]).per(20)
      when :summary
        summary_ids = Notification.where(user_id: current_user.id, category: 3).pluck(:summary_id)
        @summaries  = Summary.select(:id, :timeline_id,
                                     :user_id).where(id: summary_ids).page(params[:page]).per(20)
      when :summary_selection
        summary_ids         = Notification.where(user_id: current_user.id, category: 4).pluck(:summary_id)
        @summary_selections = Summary.select(:id, :timeline_id,
                                             :user_id).where(id: summary_ids).page(params[:page]).per(20)
      when :comment
        comment_ids = Notification.where(user_id: current_user.id, category: 5).pluck(:comment_id)
        @comments   = Comment.select(:id, :timeline_id, :reference_id,
                                     :user_id).where(id: comment_ids).page(params[:page]).per(20)
      when :selection
        @selections = Notification.where(user_id: current_user.id, category: 6).page(params[:page]).per(20)
      when :suggestions
        suggestion_ids = Notification.where(user_id: current_user.id, category: 7).pluck(:suggestion_id)
        @suggestions   = Suggestion.select(:id, :user_id, :comment ).where(id: suggestion_ids).page(params[:page]).per(20)
    end
  end

  def important
    @wins            = NotificationSelectionWin.where(user_id: current_user.id)
    @losses          = NotificationSelectionLoss.where(user_id: current_user.id)
    summary_win_ids  = NotificationSummarySelectionWin.where(user_id: current_user.id).pluck(:summary_id)
    @summary_wins    = Summary.select(:id, :timeline_id,
                                      :user_id).where(id: summary_win_ids)
    summary_loss_ids = NotificationSummarySelectionLoss.where(user_id: current_user.id).pluck(:summary_id)
    @summary_losses  = Summary.select(:id, :timeline_id,
                                      :user_id).where(id: summary_loss_ids)
    @suggestions     = NotificationSuggestion.where(user_id: current_user.id)
  end

  def delete
    if params[:notification]
      if params[:notification][:timeline_ids]
        notifs = Notification.where(user_id:     current_user.id, category: 1,
                                    timeline_id: params[:notification][:timeline_ids])
        notifs.destroy_all
        redirect_to notifications_index_path(filter: :timeline)
        return
      end
      if params[:notification][:reference_ids]
        notifs = Notification.where(user_id:      current_user.id, category: 2,
                                    reference_id: params[:notification][:reference_ids])
        notifs.destroy_all
        redirect_to notifications_index_path(filter: :reference)
        return
      end
      if params[:notification][:summary_ids]
        notifs = Notification.where(user_id:    current_user.id, category: 3,
                                    summary_id: params[:notification][:summary_ids])
        notifs.destroy_all
        redirect_to notifications_index_path(filter: :summary)
        return
      end
      if params[:notification][:sel_summary_ids]
        notifs = Notification.where(user_id:    current_user.id, category: 4,
                                    summary_id: params[:notification][:sel_summary_ids])
        notifs.destroy_all
        redirect_to notifications_index_path(filter: :summary_selection)
        return
      end
      if params[:notification][:comment_ids]
        notifs = Notification.where(user_id:    current_user.id, category: 5,
                                    comment_id: params[:notification][:comment_ids])
        notifs.destroy_all
        redirect_to notifications_index_path(filter: :comment)
        return
      end
      if params[:notification][:sel_comment_ids]
        notifs = Notification.where(user_id:    current_user.id, category: 6,
                                    comment_id: params[:notification][:sel_comment_ids])
        notifs.destroy_all
        redirect_to notifications_index_path(filter: :selection)
        return
      end
      if params[:notification][:suggestion_ids]
        notifs = Notification.where(user_id:    current_user.id, category: 7,
                                    suggestion_id: params[:notification][:suggestion_ids])
        notifs.destroy_all
        redirect_to notifications_index_path(filter: :suggestions)
        return
      end
    end
    redirect_to notifications_index_path
  end

  def delete_all
    case params[:filter]
      when :timeline.to_s
        Notification.where(user_id: current_user.id, category: 1).destroy_all
      when :reference.to_s
        Notification.where(user_id: current_user.id, category: 2).destroy_all
      when :summary.to_s
        Notification.where(user_id: current_user.id, category: 3).destroy_all
      when :summary_selection.to_s
        Notification.where(user_id: current_user.id, category: 4).destroy_all
      when :comment.to_s
        Notification.where(user_id: current_user.id, category: 5).destroy_all
      when :selection.to_s
        Notification.where(user_id: current_user.id, category: 6).destroy_all
      when :suggestions.to_s
        Notification.where(user_id: current_user.id, category: 7).destroy_all
    end
    redirect_to notifications_index_path
  end

  def delete_all_important
    NotificationSummarySelectionWin.where(user_id: current_user.id).destroy_all
    NotificationSummarySelectionLoss.where(user_id: current_user.id).destroy_all
    NotificationSelectionWin.where(user_id: current_user.id).destroy_all
    NotificationSelectionLoss.where(user_id: current_user.id).destroy_all
    NotificationSuggestion.where(user_id: current_user.id).destroy_all
    redirect_to notifications_important_path
  end

  def timeline
    Notification.find_by(user_id:     current_user.id, category: 1,
                                 timeline_id: notification_params).destroy
    redirect_to timeline_path(notification_params)
  end

  def reference
    Notification.find_by(user_id:      current_user.id, category: 2,
                                 reference_id: notification_params).destroy
    redirect_to reference_path(notification_params)
  end

  def summary
    Notification.find_by(user_id:    current_user.id, category: 3,
                                 summary_id: notification_params).destroy
    redirect_to summary_path(notification_params)
  end

  def summary_selection
    Notification.find_by(user_id:    current_user.id, category: 4,
                                 summary_id: notification_params).destroy
    redirect_to summary_path(notification_params)
  end

  def comment
    Notification.find_by(user_id:    current_user.id, category: 5,
                                 comment_id: notification_params).destroy
    redirect_to comment_path(notification_params)
  end

  def selection
    Notification.find_by(user_id:    current_user.id, category: 6,
                                 comment_id: notification_params,
                                 field:      field_params).destroy
    redirect_to comment_path(notification_params)
  end

  def suggestions
    Notification.find_by(user_id:    current_user.id, category: 7,
                         suggestion_id: notification_params).destroy
    redirect_to suggestion_path(notification_params)
  end

  def selection_win
    NotificationSelectionWin.find_by(user_id:    current_user.id,
                                             comment_id: notification_params,
                                             field:      field_params).destroy
    redirect_to comment_path(notification_params)
  end

  def summary_selection_win
    NotificationSummarySelectionWin.find_by(user_id:    current_user.id,
                                                    summary_id: notification_params).destroy
    redirect_to summary_path(notification_params)
  end

  def selection_loss
    NotificationSelectionLoss.find_by(user_id:    current_user.id,
                                              comment_id: notification_params,
                                              field:      field_params).destroy
    redirect_to comment_path(notification_params)
  end

  def summary_selection_loss
    NotificationSummarySelectionLoss.find_by(user_id:    current_user.id,
                                                     summary_id: notification_params).destroy
    redirect_to summary_path(notification_params)
  end

  def suggestion
    NotificationSuggestion.find_by(user_id:             current_user.id,
                                           suggestion_child_id: notification_params).destroy
    redirect_to suggestion_child_path(notification_params)
  end

  private

  def notification_params
    params.require(:id)
  end

  def field_params
    params.require(:field)
  end
end