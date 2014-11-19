class NotificationTimeline < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
end
