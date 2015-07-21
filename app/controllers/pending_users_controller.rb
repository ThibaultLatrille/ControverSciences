class PendingUsersController < ApplicationController
  before_action :admin_user, only: [:destroy]

  def destroy
    pending = PendingUser.find_by( user_id: params[:user_id])
    @user = User.find( params[:user_id] )
    if params[:handle] == "destroy"
      @user.destroy
    elsif params[:handle] == "accept_domain" || params[:handle] == "accept"
      if params[:handle] == "accept_domain"
        Domain.create( name: @user.email.partition("@")[2] )
      end
      @user.create_activation_digest
      @user.update_columns( activation_digest: @user.activation_digest )
      if Rails.env.production?
        mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
        message = {
            :subject=> "Activation du compte sur ControverSciences",
            :from=>"activation@controversciences.org",
            :to => @user.email,
            :html => render_to_string( :file => 'user_mailer/account_activation', layout: nil ).to_str
        }
        mg_client.send_message "controversciences.org", message
      end
    end
    pending.destroy
    redirect_to assistant_index_path
  end

end
