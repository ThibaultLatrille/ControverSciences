class Timeline < ActiveRecord::Base
  belongs_to :user
  has_many :references, dependent: :destroy
  has_many :votes, dependent: :destroy
  default_scope -> { order('rank DESC') }

  after_create :cascading_save_timeline

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 180 }

  private

  def cascading_save_timeline
      timrelation=TimelineContributor.new({user_id: self.user_id, timeline_id: self.id, bool: true})
      timrelation.save()
      Timeline.increment_counter(:nb_contributors, self.id)
  end
end
