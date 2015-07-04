class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference
end
