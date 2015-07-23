class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = "Compte activé avec succès ! Je peux dès à présent contribuer à ControverSciences !"
      log_in user
      redirect_to user
    else
      flash[:danger] = "Mon lien d'activation est corrompu ou invalide."
      redirect_to root_url
    end
  end

end
