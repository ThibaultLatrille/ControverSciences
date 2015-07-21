class PendingUser < ActiveRecord::Base
  belongs_to :user

  after_create :send_new_account_email

  def send_new_account_email
    if Rails.env.production?
      mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
      User.where(admin: true).each do |admin|
        message = {
            :subject=> "En attente #{self.user.email} sur ControverSciences",
            :from=>"pending.user@controversciences.org",
            :to => admin.email,
            :html => self.why
        }
        mg_client.send_message "controversciences.org", message
      end
    end
  end
end
