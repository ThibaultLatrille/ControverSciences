class SummaryBest < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :summary

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :summary_id, presence: true
  validates_uniqueness_of :timeline_id, :scope => [:summary_id]
end
