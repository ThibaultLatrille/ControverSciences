class ReferenceEdge < ActiveRecord::Base
  include ApplicationHelper
  belongs_to :reference
  belongs_to :timeline
  belongs_to :user
  has_many :reference_edge_votes, dependent: :destroy

  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates :timeline_id, presence: true
  validates :target, presence: true
  validates :weight, presence: true, inclusion: { in: 1..12 }
  validates_uniqueness_of :category, :scope => [:target, :reference_id]
  validate :uniqueness_validation
  validate :target_reference_diff

  after_create :cascading_create_vote

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

  def plus(category)
    ReferenceEdgeVote.where(reference_edge_id: self.id,
                                    value: true, category: category).count
  end

  def minus(category)
    ReferenceEdgeVote.where(reference_edge_id: self.id,
                                    value: false, category: category).count
  end

  private

  def uniqueness_validation
    if ReferenceEdge.find_by(reference_id: self.target, target: self.reference_id)
      errors.add(:target, ". Ce lien existe déjà")
    else
      true
    end
  end

  def cascading_create_vote
    ReferenceEdgeVote.create(user_id: self.user_id,
                             reference_edge_id: self.id,
                             category: self.category,
                             timeline_id: self.timeline_id,
                             value: true)
  end

  def target_reference_diff
    if self.reference_id == self.target
      errors.add(:target, 'Lien vers elle même')
    else
      true
    end
  end

end
