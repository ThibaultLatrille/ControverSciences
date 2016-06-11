class NotificationsController < ApplicationController
  include NotificationsHelper

  before_action :logged_in_user, only: [:index, :important, :delete, :delete_all,
                                        :delete_all_important, :redirect,
                                        :selection_redirect, :news]

  def index
    @category_count = Notification.select(:category)
                          .where(user_id: current_user.id)
                          .group("category").count
    @category_count.default = 0
    if @category_count.blank?
      flash[:info] = "Vous n'avez pas de nouvelle notification."
      redirect_to user_path(current_user)
    else
      if params[:filter]
        @filter = params[:filter].to_sym
      else
        @filter = sym_to_int_notifs_hash.invert[@category_count.max_by { |k, v| v }[0]]
      end
      @notification = Notification.new
      @models = notification_model_query(sym_to_int_notifs_hash[@filter]).page(params[:page]).per(20)
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
      when 3, 4, 13
        redirect_to summary_path(notification_params)
      when 5, 6, 14
        redirect_to comment_path(notification_params)
      when 8, 9, 12
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

  def news
    day = params[:day].present? ? params[:day].to_i : 30
    @timelines = Timeline.select(:id, :slug, :name).where(
        'created_at >= :five_days_ago',
        :five_days_ago => Time.now - day.days
    )
    @references = Reference.includes(:timeline).select(:id, :slug, :timeline_id, :title, :title_fr).where(
        'created_at >= :five_days_ago',
        :five_days_ago => Time.now - day.days
    )
    @comments = Comment.includes(:reference).includes(:timeline).select(:id, :reference_id, :timeline_id, :title_markdown).where(
        'created_at >= :five_days_ago',
        :five_days_ago => Time.now - day.days
    )
    @summaries = Summary.includes(:timeline).select(:id, :timeline_id, :content).where(
        'created_at >= :five_days_ago',
        :five_days_ago => Time.now - day.days
    )
    @frames = Frame.includes(:timeline).select(:id, :timeline_id, :name)
                  .where.not(timeline_id: @timelines.map { |t| t.id }).where(
        'created_at >= :five_days_ago',
        :five_days_ago => Time.now - day.days
    )
    @timelines = @timelines.where.not(private: true)
    @comments = @comments.where(public: true)
    @summaries = @summaries.where(public: true)
  end

  private

  def notification_params
    params.require(:id)
  end

  def filter_params
    params.require(:filter)
  end
end
