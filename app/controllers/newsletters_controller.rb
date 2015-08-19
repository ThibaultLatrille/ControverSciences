class NewslettersController < ApplicationController
  def create
    if Newsletter.create( newsletter_params )
      begin
        if Rails.env.production?
          mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
          mg_client.post("/lists/newsletter@controversciences.org/members", {address: newsletter_params[:email]})
          message = {
              :subject=> t('controllers.newsletter'),
              :from=>"contact@controversciences.org",
              :to => newsletter_params[:email],
              :html => render_to_string( :file => 'user_mailer/newsletter', layout: nil ).to_str
          }
          mg_client.send_message "controversciences.org", message
        end
        respond_to do |format|
          format.js { render 'newsletters/success', :content_type => 'text/javascript', :layout => false}
        end
      rescue Mailgun::Error => e
        respond_to do |format|
          format.js { render 'newsletters/fail', :content_type => 'text/javascript', :layout => false}
        end
      end
    else
      respond_to do |format|
        format.js { render 'newsletters/fail', :content_type => 'text/javascript', :layout => false}
      end
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:email)
  end
end
