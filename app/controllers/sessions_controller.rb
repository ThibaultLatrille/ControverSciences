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
        message  = "Ce compte n'est pas encore actif, "
        message += "le lien pour l'activer est probablement dans votre boîte mail."
        message += "Ou noyé parmis les spams qui inondent votre messagerie."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      if user
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
