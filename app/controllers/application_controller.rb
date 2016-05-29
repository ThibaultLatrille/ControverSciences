class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper
  include SessionsHelper

  before_action :set_locale

  def set_locale
    I18n.locale = extract_locale_from_subdomain || I18n.default_locale
  end

  def redirect_to_back(default = root_url)
    if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back
    else
      redirect_to default
    end
  end

  def before_render
    if logged_in?
      if current_user.private_timeline
        current_user.timelines_count = Timeline.where(user_id: current_user.id, private: true).count
      else
        current_user.invited = PrivateTimeline.where(user_id: current_user.id).count
        current_user.notif_patches = GoPatch.where(target_user_id: current_user.id).sum(:counter)
        current_user.pending_patches = UserPatch.where(user_id: current_user.id).count
        if current_user.can_switch_admin
          current_user.admin_patches = GoPatch.where.not(target_user_id: current_user.id ).sum(:counter)
          current_user.admin_dead_links = DeadLink.all.count
          current_user.admin_pending_users = PendingUser.where.not(refused: true).count
        else
          current_user.admin_patches = current_user.admin_dead_links = current_user.admin_pending_users = 0
        end
      end
    end
  end

  def render(*args)
    before_render
    super
  end

  private

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t('controllers.must_login')
      redirect_to login_url
    end
  end

  def redirect_to_home
    redirect_to root_path
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    if logged_in? && current_user.admin?
      flash.now[:danger] = t('controllers.admin_page')
    else
      flash[:danger] = t('controllers.only_admins')
      redirect_to(root_url)
    end
  end

  # Get locale code from request subdomain (like http://en.application.local:3000)
  # You have to put something like:
  #   127.0.0.1 gr.application.local
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_subdomain
    parsed_locale = request.subdomains.first
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
end
