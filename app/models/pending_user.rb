class PendingUser < ApplicationRecord
  belongs_to :user

  after_create :send_new_account_email

  def send_new_account_email
    if Rails.env.production?
      Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end
      client = Slack::Web::Client.new
      client.chat_postMessage(channel: ENV['SLACK_ADMIN_ID'], text: "En attente #{self.user.name} (#{self.user.email}) : #{self.why}")
    end
  end
end
