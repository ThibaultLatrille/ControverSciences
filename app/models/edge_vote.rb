class EdgeVote < ActiveRecord::Base
  belongs_to :user
  belongs_to :edge

  validates :user_id, presence: true
  validates :edge_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:edge_id]

end
