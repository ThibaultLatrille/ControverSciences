class ContributorSummary < ActiveRecord::Base
  belongs_to :summary
  belongs_to :user

  validates :user_id, presence: true
  validates :summary_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:summary_id]
end
