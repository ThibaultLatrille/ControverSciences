class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].transliterate)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        if PendingUser.find_by_user_id(user.id)
          flash.now[:danger] = t('controllers.session_not_validated_html')
        else
          href = send_activation_sessions_path(email: user.email)
          flash.now[:danger] = t('controllers.session_not_activated_html', href: href ).html_safe
        end
        render 'new'
      end
    elsif user
      @email             = user.email
      flash.now[:danger] = t('controllers.wrong_pwd')
      render 'new'
    else
      flash.now[:danger] = t('controllers.no_account')
      render 'new'
    end
  end

  def send_activation
    user = User.find_by(email: params[:email].transliterate)
    if user && !user.activated?
      random_choices_and_favorite
      if PendingUser.find_by_user_id(user.id)
        render 'users/invalid'
      else
        @user = user
        @user.create_activation_digest
        @user.update_columns(activation_digest: @user.activation_digest)
        if Rails.env.production?
          mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
          message   = {
              :subject => t('controllers.activation_email'),
              :from    => "ControverSciences.org <activation@controversciences.org>",
              :to      => @user.email,
              :html    => render_to_string(:file => 'user_mailer/account_activation', layout: nil).to_str
          }
          mg_client.send_message "controversciences.org", message
        end
        render 'users/success'
      end
    else
      flash[:danger] = t('controllers.user_dont_exist')
      redirect_to root_path
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
