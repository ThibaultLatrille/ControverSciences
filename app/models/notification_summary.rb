class NotificationSummary < ActiveRecord::Base
  belongs_to :user
  belongs_to :summary
end
