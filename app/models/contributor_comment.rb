class ContributorComment < ActiveRecord::Base
  belongs_to :comment
  belongs_to :user

  validates :user_id, presence: true
  validates :comment_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:comment_id]
end
