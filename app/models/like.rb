class Like < ActiveRecord::Base
  belongs_to :timeline

  validates :ip, presence: true
  validates :timeline_id, presence: true

  after_create  :cascading_save_like
  after_destroy :cascading_destroy_like
  private

  def cascading_save_like
    Timeline.update_counters(self.timeline_id, nb_likes: 1 )
  end

  def cascading_destroy_like
    Timeline.update_counters(self.timeline_id, nb_likes: -1 )
  end
end
