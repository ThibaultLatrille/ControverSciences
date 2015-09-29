class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper
  include SessionsHelper
  include ReferencesHelper

  def before_render
    if logged_in?
      current_user.empty_references = Timeline.where(user_id: current_user.id, nb_references: 0..3).count
      current_user.empty_comments   = Reference.where(user_id: current_user.id, title_fr: "").count
      current_user.empty_summaries  = Timeline.where(user_id: current_user.id, nb_summaries: 0)
                                              .where.not(nb_references: 0..3).count
      if current_user.can_switch_admin
        current_user.admin_typos = Typo.all.count
        current_user.admin_dead_links = DeadLink.all.count
        current_user.admin_pending_users = PendingUser.all.count
      else
        current_user.admin_typos = current_user.admin_dead_links = current_user.admin_pending_users = 0
      end
    end
  end

  def render(*args)
    before_render
    super
  end

  def send_notifications
    def url_options
      if Rails.env.production?
        {:host => "controversciences.org", :protocol => 'https'}
      else
        {:host => "127.0.0.1:3000"}
      end
    end
    users             = User.all.where.not(id: UserDetail.where(send_email: false).pluck(:user_id), activated: false)
    @empty_comments   = Reference.where(title_fr: "").count
    @empty_summaries  = Timeline.where(nb_summaries: 0).where.not(nb_references: 0..3).count
    @empty_references = Timeline.where(nb_references: 0..3).count
    mg_client         = Mailgun::Client.new ENV['MAILGUN_CS_API']
    names             = []
    users.find_each do |user|
      if (user.nb_notifs + user.notifications_all) > 4
        @user_notif = user
        names << "#{user.email}: #{user.name} || "
        message = {
            :subject => "#{@user_notif.name}, #{t('controllers.notifs_news')}",
            :from    => "contact@controversciences.org",
            :to      => @user_notif.email,
            :html    => render_to_string(:file => 'user_mailer/notifications', layout: nil).to_str
        }
        mg_client.send_message "controversciences.org", message
      end
    end
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end
    client      = Slack::Web::Client.new
    admin_group = client.groups_list['groups'].detect { |c| c['name'] == 'admins' }
    client.chat_postMessage(channel: admin_group['id'], text: "#{names.count} #{t('controllers.email_sent')}")
    not_activated_users = User.where(activated: false)
    @resend_activation = true
    not_activated_users.find_each do |user|
      @user = user
      @user.create_activation_digest
      @user.update_columns(activation_digest: @user.activation_digest)
      message = {
          :subject => t('controllers.activation_email'),
          :from    => "activation@controversciences.org",
          :to      => @user.email,
          :html    => render_to_string(:file => 'user_mailer/account_activation', layout: nil).to_str
      }
      mg_client.send_message "controversciences.org", message
    end
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
    if current_user.admin?
      flash.now[:danger] = t('controllers.admin_page')
    else
      flash[:danger] = t('controllers.only_admins')
      redirect_to(root_url) unless current_user.admin?
    end
  end
end
