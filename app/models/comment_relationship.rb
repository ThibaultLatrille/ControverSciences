class CommentRelationship < ActiveRecord::Base
  belongs_to :parent, class_name: "User"
  belongs_to :child, class_name: "User"
  validates :parent_id, presence: true
  validates :child_id, presence: true, uniqueness: true
end
