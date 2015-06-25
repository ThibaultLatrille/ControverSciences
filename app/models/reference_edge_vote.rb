class EdgeVote < ActiveRecord::Base
  belongs_to :reference
  belongs_to :timeline
  belongs_to :user

  attr_accessor :value

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :target, presence: true
  validates_uniqueness_of :user_id, :scope => [:reference_id, :target]

end
