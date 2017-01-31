class PrivateTimeline < ApplicationRecord
  belongs_to :user
  belongs_to :timeline

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:timeline_id]

  after_create :cascading_save

  private

  def cascading_save
    Like.create(user_id: self.user_id, timeline_id: self.timeline_id)
  end
end
