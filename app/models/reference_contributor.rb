class ReferenceContributor < ActiveRecord::Base
  belongs_to :user
  belongs_to :reference
  validates :user_id, presence: true
  validates :reference_id, presence: true

  after_create :cascading_create

  def cascading_create
    Reference.increment_counter(:nb_contributors, self.reference_id)
  end
end
