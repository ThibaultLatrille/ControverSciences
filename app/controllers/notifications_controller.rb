class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index, :important, :delete, :delete_all,
                                        :delete_all_important, :summary,
                                        :summary_selection, :selection, :timeline,
                                        :reference, :comment,
                                        :selection_redirect]

  def index
    if params[:filter]
      @filter = params[:filter].to_sym
    else
      if Notification.where(user_id: current_user.id, category: 1).count > 0
        @filter = :timeline
      else
        if Notification.where(user_id: current_user.id, category: 8).count > 0
          @filter = :frame
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
                    if Notification.where(user_id: current_user.id, category: 9).count > 0
                      @filter = :frame_selection
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
    end
    @notification = Notification.new
    case @filter
      when :timeline
        timeline_ids = Notification.where(user_id: current_user.id, category: 1).pluck(:timeline_id)
        @timelines   = Timeline.includes(:tags).select(:id, :slug, :name,
                                       :user_id).where(id: timeline_ids).page(params[:page]).per(20)
      when :frame
        frame_ids = Notification.where(user_id: current_user.id, category: 8).pluck(:frame_id )
        @frames   = Frame.select(:id, :timeline_id,
                                       :user_id).where(id: frame_ids).page(params[:page]).per(20)
      when :frame_selection
        frame_ids = Notification.where(user_id: current_user.id, category: 9).pluck(:frame_id)
        @frame_selections   = Frame.select(:id, :timeline_id,
                                 :user_id).where(id: frame_ids).page(params[:page]).per(20)
      when :reference
        reference_ids = Notification.where(user_id: current_user.id, category: 2).pluck(:reference_id)
        @references   = Reference.select(:id, :slug, :timeline_id, :title,
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
    end
  end

  def important
    @notification_selections = NotificationSelection.where(user_id: current_user.id).group_by{ |notif| notif.win }
    puts @notification_selections
    if current_user.private_timeline
      @typos = []
    else
      @typos = Typo.where( target_user_id: current_user.id )
    end
  end

  def delete
    if params[:notification]
      if params[:notification][:timeline_ids]
        Notification.where(user_id:     current_user.id, category: 1,
                                    timeline_id: params[:notification][:timeline_ids]).destroy_all
        redirect_to notifications_index_path(filter: :timeline)
        return
      end
      if params[:notification][:reference_ids]
        Notification.where(user_id:      current_user.id, category: 2,
                                    reference_id: params[:notification][:reference_ids]).destroy_all
        redirect_to notifications_index_path(filter: :reference)
        return
      end
      if params[:notification][:summary_ids]
        Notification.where(user_id:    current_user.id, category: 3,
                                    summary_id: params[:notification][:summary_ids]).destroy_all
        redirect_to notifications_index_path(filter: :summary)
        return
      end
      if params[:notification][:sel_summary_ids]
        Notification.where(user_id:    current_user.id, category: 4,
                                    summary_id: params[:notification][:sel_summary_ids]).destroy_all
        redirect_to notifications_index_path(filter: :summary_selection)
        return
      end
      if params[:notification][:comment_ids]
        Notification.where(user_id:    current_user.id, category: 5,
                                    comment_id: params[:notification][:comment_ids]).destroy_all
        redirect_to notifications_index_path(filter: :comment)
        return
      end
      if params[:notification][:sel_comment_ids]
        Notification.where(user_id:    current_user.id, category: 6,
                                    comment_id: params[:notification][:sel_comment_ids]).destroy_all
        redirect_to notifications_index_path(filter: :selection)
        return
      end
      if params[:notification][:frame_ids]
        Notification.where(user_id:    current_user.id, category: 8,
                                    frame_id: params[:notification][:frame_ids]).destroy_all
        redirect_to notifications_index_path(filter: :frame)
        return
      end
      if params[:notification][:sel_frame_ids]
        Notification.where(user_id:    current_user.id, category: 9,
                                    frame_id: params[:notification][:sel_frame_ids]).destroy_all
        redirect_to notifications_index_path(filter: :frame_selection)
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
      when :frame.to_s
        Notification.where(user_id: current_user.id, category: 8).destroy_all
      when :frame_selection.to_s
        Notification.where(user_id: current_user.id, category: 9).destroy_all
    end
    redirect_to notifications_index_path
  end

  def delete_all_important
    NotificationSelection.where(user_id: current_user.id).destroy_all
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

  def frame
    Notification.find_by(user_id:    current_user.id, category:8,
                         frame_id: notification_params).destroy
    redirect_to frame_path(notification_params)
  end

  def frame_selection
    Notification.find_by(user_id:    current_user.id, category: 9,
                         frame_id: notification_params).destroy
    redirect_to frame_path(notification_params)
  end

  def selection_redirect
    notif = NotificationSelection.find( notification_params )
    notif.destroy
    if notif.frame_id
      redirect_to frame_path(notif.frame_id)
    elsif notif.comment_id
      redirect_to comment_path(notif.comment_id)
    else
      redirect_to summary_path(notif.summary_id)
    end
  end

  private

  def notification_params
    params.require(:id)
  end

  def field_params
    params.require(:field)
  end
end