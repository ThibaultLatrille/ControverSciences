class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      if Rails.env.production?
        mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
        mg_client.post("/lists/contributeurs@controversciences.org/members", {address: user.email})
      end
      flash[:success] = t('controllers.account_activated')
      log_in user
      redirect_to user
    else
      flash[:danger] = t('controllers.activation_invalid')
      redirect_to root_url
    end
  end

end
