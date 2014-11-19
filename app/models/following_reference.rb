class FollowingReference < ActiveRecord::Base
  belongs_to :user
  belongs_to :reference

  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:reference_id]
end
