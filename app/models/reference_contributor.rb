class ReferenceContributor < ApplicationRecord
  belongs_to :user
  belongs_to :reference
  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:reference_id]

  after_create :cascading_create
  after_destroy :cascading_destroy

  def cascading_create
    Reference.increment_counter(:nb_contributors, self.reference_id)
  end

  def cascading_destroy
    Reference.decrement_counter(:nb_contributors, self.reference_id)
  end
end
