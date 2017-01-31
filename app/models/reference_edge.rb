class ReferenceEdge < ApplicationRecord
  include ApplicationHelper
  belongs_to :reference
  belongs_to :timeline
  belongs_to :user
  has_many :reference_edge_votes, dependent: :destroy

  attr_accessor :from_ids

  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates :timeline_id, presence: true
  validates :target, presence: true
  validates :weight, presence: true, inclusion: { in: 1..12 }
  validate :uniqueness_validation
  validates_uniqueness_of :target, :scope => [:reference_id]
  validate :target_reference_diff

  after_create :cascading_create_vote

  def target_title
    Reference.select(:title).find(self.target).title
  end

  def target_title_fr
    Reference.select(:title_fr).find(self.target).title_fr
  end

  def target_short
    Reference.select(:title, :year, :id, :author).find(self.target)
  end

  def reference_short
    Reference.select(:title, :year, :id, :author).find(self.reference_id)
  end

  def reference_title
    Reference.select(:title).find(self.reference_id).title
  end

  def reference_title_fr
    Reference.select(:title_fr).find(self.reference_id).title_fr
  end

  def plus_count
    ReferenceEdgeVote.where(reference_edge_id: self.id,
                                    value: true).count
  end

  def minus_count
    ReferenceEdgeVote.where(reference_edge_id: self.id,
                                    value: false).count
  end

  private

  def uniqueness_validation
    if ReferenceEdge.find_by(reference_id: self.reference_id, target: self.reference_id)
      errors.add(:target, ". Ce lien existe déjà")
    else
      true
    end
  end

  def cascading_create_vote
    ReferenceEdgeVote.create(user_id: self.user_id,
                             reference_edge_id: self.id,
                             timeline_id: self.timeline_id,
                             value: true)
  end

  def target_reference_diff
    if self.reference_id == self.target
      errors.add(:target, 'Lien vers elle même')
    elsif (Reference.select(:year).find(self.target).year - Reference.select(:year).find(self.reference_id).year) > 0
      errors.add(:base, 'La référence citée est plus récente que la référence qui cite, impossible !')
    else
      true
    end
  end

end
