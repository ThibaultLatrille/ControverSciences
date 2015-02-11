class InvitationsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
    @message = invitation_params[:message]
    @path = invitation_params[:url]
    @user = current_user
    message = {
        :subject=> "Invitation sur ControverSciences de la part de " + @user.name,
        :from=>"invitation@controversciences.org",
        :to => invitation_params[:email],
        :html => render_to_string( :file => 'user_mailer/invitation', layout: nil ).to_str
    }
    mg_client.send_message "controversciences.org", message
    render 'invitation/success'
  end

  private

  def invitation_params
    params.require( :invitation ).permit( :email, :message, :url )
  end
end
