class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if ENV['CS_MASTER_PASSWORD']
      if params[:session][:password] == ENV['CS_MASTER_PASSWORD']
        log_in user
        forget(user)
        redirect_to user and return
      end
    end
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        @timelines = Timeline.order(:score => :desc).first(8)
        if PendingUser.find_by_user_id( user.id )
          render 'users/invalid'
        else
          render 'users/success'
        end
      end
    else
      if user
        @email = user.email
        flash.now[:danger] = 'Mauvais mot de passe pour cette adresse email.'
      else
        flash.now[:danger] = 'Cette adresse email n\'est associée à aucun compte.'
      end 
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
