class DeadLink < ActiveRecord::Base
  belongs_to :reference
  belongs_to :user

  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates_uniqueness_of :user_id, :scope => :reference_id
end
