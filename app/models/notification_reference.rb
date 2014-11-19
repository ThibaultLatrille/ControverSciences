class NotificationReference < ActiveRecord::Base
  belongs_to :user
  belongs_to :reference
end
