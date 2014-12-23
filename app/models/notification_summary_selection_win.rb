class NotificationSummarySelectionWin < ActiveRecord::Base
  belongs_to :summary
  belongs_to :user
end
