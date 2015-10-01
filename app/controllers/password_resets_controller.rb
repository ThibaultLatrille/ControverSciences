class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      if @user.activated?
        @user.create_reset_digest
        if Rails.env.production?
          mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
          message = {
              :subject=> t('controllers.reset_pwd_email'),
              :from=>"ControverSciences.org <reinitialisation@controversciences.org>",
              :to => @user.email,
              :html => render_to_string( :file => 'user_mailer/password_reset', layout: nil ).to_str
          }
          mg_client.send_message "controversciences.org", message
        end
        flash[:info] = t('controllers.reseted_pwd_email')
        redirect_to root_url
      else
        @timelines = Timeline.order(:score => :desc).first(4)
        if PendingUser.find_by_user_id( @user.id )
          render 'users/invalid'
        else
          @user.create_activation_digest
          @user.update_columns( activation_digest: @user.activation_digest )
          if Rails.env.production?
            mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
            message = {
                :subject=> t('controllers.activation_email'),
                :from=>"ControverSciences.org <activation@controversciences.org>",
                :to => @user.email,
                :html => render_to_string( :file => 'user_mailer/account_activation', layout: nil ).to_str
            }
            mg_client.send_message "controversciences.org", message
          end
          render 'users/success'
        end
      end
    else
      flash.now[:danger] = t('controllers.no_account_id')
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.password_reset_expired?
      flash[:danger] = t('controllers.expired_reset')
      redirect_to new_password_reset_path
    elsif @user.update_attributes(user_params)
      if (params[:user][:password].blank? &&
          params[:user][:password_confirmation].blank?)
        flash.now[:danger] = t('controllers.pwd_or_confirm_error')
        render 'edit'
      else
        flash[:success] = t('controllers.pwd_updated')
        log_in @user
        redirect_to @user
      end
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
    unless @user && @user.authenticated?(:reset, params[:id])
      redirect_to root_url
    end
  end
end
