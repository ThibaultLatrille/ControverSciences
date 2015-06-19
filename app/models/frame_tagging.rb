class FrameTagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :frame
end
