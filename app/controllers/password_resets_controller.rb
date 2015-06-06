class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      if @user.activated?
        @user.create_reset_digest
        mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
        message = {
            :subject=> "Réinitialisation du mot de passe sur ControverSciences",
            :from=>"reinitialisation@controversciences.org",
            :to => @user.email,
            :html => render_to_string( :file => 'user_mailer/password_reset', layout: nil ).to_str
        }
        mg_client.send_message "controversciences.org", message
        flash[:info] = "Un email vous a été envoyé."
        redirect_to root_url
      else
        if logged_in?
          @my_likes = Like.where(user_id: current_user.id).pluck( :timeline_id )
        end
        @timelines = Timeline.order(:score => :desc).first(8)
        if PendingUser.find_by_user_id( @user.id )
          render 'users/invalid'
        else
          @user.create_activation_digest
          @user.update_columns( activation_digest: @user.activation_digest )
          mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
          message = {
              :subject=> "Activation du compte sur ControverSciences",
              :from=>"activation@controversciences.org",
              :to => @user.email,
              :html => render_to_string( :file => 'user_mailer/account_activation', layout: nil ).to_str
          }
          mg_client.send_message "controversciences.org", message
          render 'users/success'
        end
      end
    else
      flash.now[:danger] = "Aucun compte n'est lié à cette adresse mail."
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.password_reset_expired?
      flash[:danger] = "Réinitialisation de mot de passe expirée."
      redirect_to new_password_reset_path
    elsif @user.update_attributes(user_params)
      if (params[:user][:password].blank? &&
          params[:user][:password_confirmation].blank?)
        flash.now[:danger] = "Erreur de mot de passe ou de confirmation."
        render 'edit'
      else
        flash[:success] = "Mot de passe modifié."
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