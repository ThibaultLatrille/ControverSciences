class NotificationFrameSelectionLoss < ActiveRecord::Base
  belongs_to :frame
  belongs_to :summary
end
