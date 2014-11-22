class Link < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment
  belongs_to :reference
  belongs_to :timeline

  validates :user_id, presence: true
  validates :comment_id, presence: true
  validates :reference_id, presence: true
  validates :timeline_id, presence: true

  validates_uniqueness_of :user_id, :scope => [:comment_id ,:reference_id]
end
