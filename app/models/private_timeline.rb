class PrivateTimeline < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates_uniqueness_of :timeline_id, :scope => [:user_id]
end
