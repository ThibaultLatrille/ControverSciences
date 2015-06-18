class NotificationFrameSelectionWin < ActiveRecord::Base
  belongs_to :frame
  belongs_to :user
end
