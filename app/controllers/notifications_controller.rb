class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index, :important, :delete, :delete_all,
                                        :delete_all_important, :redirect,
                                        :selection_redirect]

  def index
    if params[:filter]
      @filter = params[:filter].to_sym
    else
      @filter = sym_to_int_notifs_hash.invert[Notification.select(:category)
                                      .where(user_id: current_user.id)
                                      .group_by { |t| t.category }
                                      .max_by { |k, v| v.length }[0]]
    end
    @notification = Notification.new
    category = sym_to_int_notifs_hash[@filter]
    if category == 6
      @selections = Notification.where(user_id: current_user.id, category: 6).page(params[:page]).per(20)
    else
      ids = Notification.where(user_id: current_user.id, category: category)
                .pluck(category_to_model_hash[category])
      case category
        when 1
          @timelines = Timeline.includes(:tags).select(:id, :slug, :name, :user_id)
                           .where(id: ids).page(params[:page]).per(20)
        when 2
          @references = Reference.select(:id, :slug, :timeline_id, :title, :user_id)
                        .where(id: ids).page(params[:page]).per(20)
        when 3, 4
          @summaries = Summary.select(:id, :timeline_id, :user_id)
                           .where(id: ids).page(params[:page]).per(20)
        when 5
          @comments = Comment.select(:id, :timeline_id, :reference_id, :user_id)
                          .where(id: ids).page(params[:page]).per(20)
        when 8, 9
          @frames = Frame.select(:id, :timeline_id, :user_id)
                        .where(id: ids).page(params[:page]).per(20)
        when 10
          @suggestions = Suggestion.select(:id, :comment, :name, :user_id)
                             .where(id: ids).page(params[:page]).per(20)
        when 11
          @suggestions = SuggestionChild.select(:id, :comment, :name, :user_id)
                                     .where(id: ids).page(params[:page]).per(20)
        else
          nil
      end
    end
  end

  def important
    @notification_selections = NotificationSelection.where(user_id: current_user.id).group_by { |notif| notif.win }
  end

  def delete
    filter = params[:notification][:filter].to_sym
    category = sym_to_int_notifs_hash[filter]
    if category
      Notification.where(user_id: current_user.id, category: category,
                         category_to_model_hash[category] => params[:notification][:ids]).destroy_all

    end
    redirect_to notifications_index_path(filter: filter)
  end

  def delete_all
    Notification.where(user_id: current_user.id, category: sym_to_int_notifs_hash[params[:filter].to_sym]).destroy_all
    redirect_to notifications_index_path
  end

  def delete_all_important
    NotificationSelection.where(user_id: current_user.id).destroy_all
    redirect_to notifications_important_path
  end

  def redirect
    category = sym_to_int_notifs_hash[filter_params.to_sym]
    Notification.find_by(user_id: current_user.id, category: category, field: params[:field],
                         category_to_model_hash[category] => notification_params).destroy
    case category
      when 1
        redirect_to timeline_path(notification_params)
      when 2
        redirect_to reference_path(notification_params)
      when 3, 4
        redirect_to summary_path(notification_params)
      when 5, 6
        redirect_to comment_path(notification_params)
      when 8, 9
        redirect_to frame_path(notification_params)
      when 10
        redirect_to suggestion_path(notification_params)
      when 11
        redirect_to suggestion_child_path(notification_params)
      else
        redirect_to notifications_index_path(filter: filter_params)
    end
  end

  def selection_redirect
    notif = NotificationSelection.find(notification_params)
    notif.destroy
    if notif.frame_id
      redirect_to frame_path(notif.frame_id)
    elsif notif.comment_id
      redirect_to comment_path(notif.comment_id)
    elsif notif.summary_id
      redirect_to summary_path(notif.summary_id)
    else
      redirect_to notifications_important_path
    end
  end

  private

  def notification_params
    params.require(:id)
  end

  def filter_params
    params.require(:filter)
  end
end