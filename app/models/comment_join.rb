class CommentJoin < ActiveRecord::Base
  belongs_to :reference
  belongs_to :comment

  validates :reference_id, presence: true
  validates :comment_id, presence: true
  validates :field, presence: true, inclusion: { in: 0..7 }
end
