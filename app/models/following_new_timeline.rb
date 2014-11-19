class FollowingNewTimeline < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true, uniqueness: true
end
