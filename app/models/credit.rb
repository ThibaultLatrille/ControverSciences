class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :summary
end
