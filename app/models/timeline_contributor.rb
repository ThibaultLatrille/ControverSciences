class TimelineContributor < ApplicationRecord
  belongs_to :user
  belongs_to :timeline
  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:timeline_id]

  after_create :cascading_create
  after_destroy :cascading_destroy

  def cascading_create
    Timeline.increment_counter(:nb_contributors, self.timeline_id)
  end

  def cascading_destroy
    Timeline.decrement_counter(:nb_contributors, self.timeline_id)
  end
end
