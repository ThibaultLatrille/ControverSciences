class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = "Compte activé avec succès ! Vous pouvez dès à présent contribuer à ControverSciences !"
      log_in user
      redirect_to user
    else
      flash[:danger] = "Lien d'activation corrompu ou invalide."
      redirect_to root_url
    end
  end

end
