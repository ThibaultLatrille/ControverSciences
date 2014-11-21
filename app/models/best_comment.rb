class BestComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :reference
  belongs_to :comment

  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates :comment_id, presence: true
  validates :field, presence: true, inclusion: { in: 1..5 }
  validates_uniqueness_of :reference_id, :scope => [:field, :comment_id]
end
