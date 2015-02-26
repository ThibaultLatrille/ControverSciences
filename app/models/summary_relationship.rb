class SummaryRelationship < ActiveRecord::Base
  belongs_to :parent, class_name: "Summary", foreign_key: "parent_id"
  belongs_to :child, class_name: "Summary", foreign_key: "child_id"
  validates :parent_id, presence: true
  validates :child_id, presence: true, uniqueness: true
end
