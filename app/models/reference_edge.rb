class ReferenceEdge < ActiveRecord::Base
  belongs_to :reference
  belongs_to :timeline
  belongs_to :user
  has_many :reference_edge_votes, dependent: :destroy

  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates :timeline_id, presence: true
  validates :target, presence: true
  validates :weight, presence: true, inclusion: { in: 1..12 }
  validates_uniqueness_of :reference_id, :scope => [:target]

  def target_title
    Reference.select(:title).find(self.target).title
  end

  def target_title_fr
    Reference.select(:title_fr).find(self.target).title_fr
  end

  def reference_title
    Reference.select(:title).find(self.reference_id).title
  end

  def reference_title_fr
    Reference.select(:title_fr).find(self.reference_id).title_fr
  end

  def plus
    ReferenceEdgeVote.where(reference_edge_id: self.id, value: true).count
  end

  def minus
    ReferenceEdgeVote.where(reference_edge_id: self.id, value: false).count
  end

  def reverse
    if self.reversible
      ReferenceEdge.find_by( reference_id: self.target )
    end
  end
end
