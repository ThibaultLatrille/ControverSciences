class TimelineContributor < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  validates :user_id, presence: true
  validates :timeline_id, presence: true

  after_create :cascading_create

  def cascading_create
    Timeline.increment_counter(:nb_contributors, self.timeline_id)
  end
end
