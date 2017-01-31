class EdgeVote < ApplicationRecord
  belongs_to :user
  belongs_to :edge

  validates :user_id, presence: true
  validates :edge_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:edge_id]

  after_create :cascading_create_vote
  after_destroy :cascading_destroy_vote

  private

  def cascading_create_vote
    if self.value
      Edge.increment_counter(:plus, self.edge_id)
      Edge.increment_counter(:balance, self.edge_id)
    else
      Edge.increment_counter(:minus, self.edge_id)
      Edge.decrement_counter(:balance, self.edge_id)
    end
  end

  def cascading_destroy_vote
    if self.value
      Edge.decrement_counter(:plus, self.edge_id)
      Edge.decrement_counter(:balance, self.edge_id)
    else
      Edge.decrement_counter(:minus, self.edge_id)
      Edge.increment_counter(:balance, self.edge_id)
    end
  end

end
