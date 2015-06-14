class NotificationTypo < ActiveRecord::Base
  belongs_to :user
  belongs_to :typo
end
