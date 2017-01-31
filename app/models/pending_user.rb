class PendingUser < ApplicationRecord
  belongs_to :user

  after_create :send_new_account_email

  def send_new_account_email
    if Rails.env.production?
      Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end
      client = Slack::Web::Client.new
      admin_group = client.groups_list['groups'].detect { |c| c['name'] == 'admins' }
      client.chat_postMessage(channel: admin_group['id'], text: "En attente #{self.user.name} (#{self.user.email}) : #{self.why}")
    end
  end
end
