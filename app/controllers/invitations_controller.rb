class InvitationsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    UserMailer.invitation({user_from: current_user,
                          to: invitation_params[:email],
                          message: invitation_params[:message],
                          path: invitation_params[:url]}).deliver
    render 'invitation/success'
  end

  private

  def invitation_params
    params.require( :invitation ).permit( :email, :message, :url )
  end
end
