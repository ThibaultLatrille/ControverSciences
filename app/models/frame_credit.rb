class FrameCredit < ActiveRecord::Base
  belongs_to :timeline
  belongs_to :user
  belongs_to :frame
end
