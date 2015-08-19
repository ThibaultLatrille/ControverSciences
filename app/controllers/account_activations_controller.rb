class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      flash[:success] = t('controllers.account_activated')
      log_in user
      redirect_to user
    else
      flash[:danger] = t('controllers.activation_invalid')
      redirect_to root_url
    end
  end

end
