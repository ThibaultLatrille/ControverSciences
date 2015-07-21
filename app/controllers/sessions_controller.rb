class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        if logged_in?
          @my_likes = Like.where(user_id: current_user.id).pluck( :timeline_id )
        end
        @timelines = Timeline.order(:score => :desc).first(8)
        if PendingUser.find_by_user_id(user.id)
          render 'users/invalid'
        else
          @user = user
          @user.create_activation_digest
          @user.update_columns(activation_digest: @user.activation_digest)
          if Rails.env.production?
            mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
            message   = {
                :subject => "Activation du compte sur ControverSciences",
                :from    => "activation@controversciences.org",
                :to      => @user.email,
                :html    => render_to_string(:file => 'user_mailer/account_activation', layout: nil).to_str
            }
            mg_client.send_message "controversciences.org", message
          end
          render 'users/success'
        end
      end
    elsif user
      if user.activated?
        @email             = user.email
        flash.now[:danger] = 'Mauvais mot de passe pour cette adresse email.'
        render 'new'
      else
        if logged_in?
          @my_likes = Like.where(user_id: current_user.id).pluck( :timeline_id )
        end
        @timelines = Timeline.order(:score => :desc).first(8)
        if PendingUser.find_by_user_id(user.id)
          render 'users/invalid'
        else
          @user = user
          @user.create_activation_digest
          @user.update_columns(activation_digest: @user.activation_digest)
          if Rails.env.production?
            mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
            message   = {
                :subject => "Activation du compte sur ControverSciences",
                :from    => "activation@controversciences.org",
                :to      => @user.email,
                :html    => render_to_string(:file => 'user_mailer/account_activation', layout: nil).to_str
            }
            mg_client.send_message "controversciences.org", message
          end
          render 'users/success'
        end
      end
    else
      flash.now[:danger] = 'Cette adresse email n\'est associée à aucun compte.'
      render 'new'
    end
  end

  def as_admin
    if current_user.admin
      user = User.find(params[:id])
      log_in user
      forget(user)
      redirect_to user and return
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
