class PendingUser < ActiveRecord::Base
  belongs_to :user

  after_create :send_new_account_email

  def send_new_account_email
    UserMailer.new_account( self ).deliver
  end
end
