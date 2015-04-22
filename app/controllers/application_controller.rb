class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper
  include SessionsHelper
  include ReferencesHelper

  def send_notifications
    users = User.all
    @empty_comments = Reference.where( title_fr: nil ).count
    @empty_summaries = Timeline.where( nb_summaries: 0 ).where.not( nb_references: 0..3 ).count
    @empty_references = Timeline.where( nb_references: 0..3 ).count
    mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
    users.each do |user|
      if (user.notifications_all_important + user.notifications_all ) > 5
        @user_notif = user
        message = {
            :subject=> "#{@user_notif.name}, les nouveautés qui vous intéressent sur ControverSciences",
            :from=>"contact@controversciences.org",
            :to => @user_notif.email,
            :html => render_to_string( :file => 'user_mailer/notifications', layout: nil ).to_str
        }
        mg_client.send_message "controversciences.org", message
      end
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
    flash[:danger] = "Vous devez être Admin pour accéder à cette page."
    redirect_to(root_url) unless current_user.admin?
  end
end
