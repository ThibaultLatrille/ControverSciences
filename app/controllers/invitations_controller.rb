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
      begin
        if Rails.env.production?
          mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
          subject = "#{@invitation.user_name} et ControverSciences vous invite à découvrir la #{@invitation.timeline_id ? "controverse \"#{@invitation.timeline.name}\"" : "référence \"#{@invitation.reference.title_display}\""}"
          message = {
              :subject =>  (CGI.unescapeHTML subject),
              :from=>"#{@invitation.user_name} <invitation@controversciences.org>",
              :to => @invitation.target_email,
              :html => render_to_string( :file => 'user_mailer/invitation', layout: nil ).to_str
          }
          mg_client.send_message "controversciences.org", message
        end
        respond_to do |format|
          format.js { render 'invitations/success', :content_type => 'text/javascript', :layout => false}
        end
      rescue Mailgun::Error => e
        respond_to do |format|
          format.js { render 'invitations/server_error', :content_type => 'text/javascript', :layout => false}
        end
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
