class Invitation < ApplicationRecord
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference

  validates :user_name, presence: true
  validates :target_email, presence: true, :email => true

end
