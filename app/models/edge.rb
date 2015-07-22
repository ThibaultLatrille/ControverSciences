class Edge < ActiveRecord::Base
  belongs_to :timeline
  belongs_to :user

  has_many :edge_votes, dependent: :destroy

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :target, presence: true
  validates :weight, presence: true, inclusion: { in: 1..12 }
  validates_uniqueness_of :timeline_id, :scope => [:target]
  validate :uniqueness_validation
  validate :target_timeline_diff

  after_create :cascading_create_vote

  def target_name
    Timeline.select(:name).find(self.target).name
  end

  def timeline_name
    Timeline.select(:name).find(self.timeline_id).name
  end

  private

  def uniqueness_validation
    if Edge.find_by(timeline_id: self.target, target: self.timeline_id)
      errors.add(:target, ". Ce lien existe déjà")
    else
      true
    end
  end

  def cascading_create_vote
    EdgeVote.create(user_id: self.user_id,
                    edge_id: self.id,
                    value: true)
  end

  def target_timeline_diff
    if self.timeline_id == self.target
      errors.add(:target, 'Lien vers elle même')
    else
      true
    end
  end
end
