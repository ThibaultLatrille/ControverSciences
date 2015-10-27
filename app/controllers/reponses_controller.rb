class ReponsesController < ApplicationController
  def create
    @reponse_id = params[:reponse][:reponse_id]
    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end
    client      = Slack::Web::Client.new
    admin_group = client.groups_list['groups'].detect { |c| c['name'] == 'reponse-ra' }
    text = "Reponse de #{params[:reponse][:author]}. \n " +
        " A propos de #{params[:reponse][:title]} : \n " + params[:reponse][:body]
    client.chat_postMessage(channel: admin_group['id'], text: text)
    respond_to do |format|
      format.js { render 'reponses/success', :content_type => 'text/javascript', :layout => false}
    end
  end
end
