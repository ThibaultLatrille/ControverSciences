class ReferenceEdgeVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :reference_edge
  belongs_to :timeline

  validates :timeline_id, presence: true
  validates :user_id, presence: true
  validates :reference_edge_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:reference_edge_id]

  after_create :cascading_create_vote
  after_destroy :cascading_destroy_vote

  private

  def cascading_create_vote
    if self.value
      ReferenceEdge.increment_counter(:plus, self.reference_edge_id)
      ReferenceEdge.increment_counter(:balance, self.reference_edge_id)
    else
      ReferenceEdge.increment_counter(:minus, self.reference_edge_id)
      ReferenceEdge.decrement_counter(:balance, self.reference_edge_id)
    end
  end

  def cascading_destroy_vote
    if self.value
      ReferenceEdge.decrement_counter(:plus, self.reference_edge_id)
      ReferenceEdge.decrement_counter(:balance, self.reference_edge_id)
    else
      ReferenceEdge.decrement_counter(:minus, self.reference_edge_id)
      ReferenceEdge.increment_counter(:balance, self.reference_edge_id)
    end
  end

end
