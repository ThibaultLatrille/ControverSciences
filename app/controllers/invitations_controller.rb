class InvitationsController < ApplicationController
  def create
    UserMailer.invitation({user_from: current_user,
                          to: invitation_params[:email],
                          message: invitation_params[:message],
                          path: timeline_url(invitation_params[:message])}).deliver
    render 'invitation/success'
  end

  private

  def invitation_params
    params.require( :invitation ).permit( :email, :message )
  end
end
