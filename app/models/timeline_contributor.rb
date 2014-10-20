class TimelineContributor < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  validates :user_id, presence: true
  validates :timeline_id, presence: true
end
