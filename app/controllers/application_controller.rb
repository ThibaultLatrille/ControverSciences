class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper
  include ReferencesHelper

  before_filter :if_logged_in

  def if_logged_in
    if logged_in?
      current_user.empty_references = Timeline.where(user_id: current_user.id, nb_references: 0..3 ).count
      current_user.empty_comments = Reference.where(user_id: current_user.id, title_fr: nil).count
      current_user.empty_summaries = Timeline.where(user_id: current_user.id, nb_summaries: 0)
                                             .where.not( nb_references: 0..3 )
                                             .where.not(nb_comments: 0..3).count
    end
  end


  def send_notifications
    users = User.all.where.not( id: UserDetail.where( send_email: false).pluck(:user_id), activated: false )
    @empty_comments = Reference.where( title_fr: nil ).count
    @empty_summaries = Timeline.where( nb_summaries: 0 ).where.not( nb_references: 0..3 ).count
    @empty_references = Timeline.where( nb_references: 0..3 ).count
    if Rails.env.production?
      mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
      names = []
      users.each do |user|
        if (user.nb_notifs + user.notifications_all ) > 4
          @user_notif = user
          names << "#{user.email}: #{user.name} || "
          message = {
              :subject=> "#{@user_notif.name}, les nouveautés qui vous intéressent sur ControverSciences",
              :from=>"contact@controversciences.org",
              :to => @user_notif.email,
              :html => render_to_string( :file => 'user_mailer/notifications', layout: nil ).to_str
          }
          mg_client.send_message "controversciences.org", message
        end
      end
      Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end
      client = Slack::Web::Client.new
      admin_group = client.groups_list['groups'].detect { |c| c['name'] == 'admins' }
      client.chat_postMessage(channel: admin_group['id'], text: "#{names.count} emails ont été envoyé aux contributeurs")
    end
  end

  private

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Vous devez vous connecter/inscrire pour explorer ce recoin de ControverSciences."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    if current_user.admin?
      flash.now[:danger] = "Vous êtes sur une page dedié aux admins."
    else
      flash[:danger] = "Uniquement les admins peuvent effectuer ces actions."
      redirect_to(root_url) unless current_user.admin?
    end
  end
end
