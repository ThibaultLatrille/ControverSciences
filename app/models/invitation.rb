class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference

  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates :user_name, presence: true
  validates :target_email, presence: true, format: { with: VALID_EMAIL_REGEX }

end
