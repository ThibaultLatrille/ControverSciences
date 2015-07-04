class InvitationsController < ApplicationController

  def new
    @invitation = Invitation.new
    @invitation.timeline_id = params[:timeline_id]
    @invitation.reference_id = params[:reference_id]
    if logged_in?
      @invitation.user_id = current_user.id
      @invitation.user_name = current_user.name
    end
    respond_to do |format|
      format.js { render 'invitations/new', :content_type => 'text/javascript', :layout => false}
    end
  end

  def create
    @invitation = Invitation.new( invitation_params )
    if logged_in?
      @invitation.user_id = current_user.id
    end
    if @invitation.save
      respond_to do |format|
        format.js { render 'invitations/success', :content_type => 'text/javascript', :layout => false}
      end
    else
      respond_to do |format|
        format.js { render 'invitations/fail', :content_type => 'text/javascript', :layout => false}
      end
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:message, :user_name, :target_email, :target_name, :timeline_id, :reference_id)
  end
end
