class SummaryLink < ApplicationRecord
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference
  belongs_to :summary

  validates :user_id, presence: true
  validates :summary_id, presence: true
  validates :reference_id, presence: true
  validates :timeline_id, presence: true

  validates_uniqueness_of :user_id, :scope => [:summary_id ,:reference_id]
end
