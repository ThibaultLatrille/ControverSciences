class ReferenceEdgeVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :reference_edge
  belongs_to :timeline

  validates :timeline_id, presence: true
  validates :user_id, presence: true
  validates :reference_edge_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:reference_edge_id]

end
