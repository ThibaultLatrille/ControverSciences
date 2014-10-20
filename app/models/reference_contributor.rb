class ReferenceContributor < ActiveRecord::Base
  belongs_to :user
  belongs_to :reference
  validates :user_id, presence: true
  validates :reference_id, presence: true
end
