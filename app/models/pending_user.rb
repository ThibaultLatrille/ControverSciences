class PendingUser < ActiveRecord::Base
  belongs_to :user

  after_create :send_new_account_email

  def send_new_account_email
    mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
    message = {
        :subject=> "En attente #{self.user.email} sur ControverSciences",
        :from=>"pending.user@controversciences.org",
        :to => "thibault.latrille@ens-lyon.fr",
        :html => self.why
    }
    mg_client.send_message "controversciences.org", message
    message = {
        :subject=> "En attente #{self.user.email} sur ControverSciences",
        :from=>"pending.user@controversciences.org",
        :to => "sombrenard@gmail.com",
        :html => self.why
    }
    mg_client.send_message "controversciences.org", message
  end
end
