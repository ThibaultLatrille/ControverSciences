class Suggestion < ActiveRecord::Base
  belongs_to :user
  has_many :suggestion_children

  validates :name, presence: true, length: { maximum: 120 }
  validates :comment, presence: true, length: {maximum: 480 }

end
