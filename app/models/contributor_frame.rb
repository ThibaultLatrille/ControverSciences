class ContributorFrame < ActiveRecord::Base
  belongs_to :frame
  belongs_to :user

  validates :user_id, presence: true
  validates :frame_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:frame_id]
end
