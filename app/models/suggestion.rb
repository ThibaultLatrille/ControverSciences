class Suggestion < ActiveRecord::Base
  belongs_to :user
  has_many :suggestion_children, dependent: :destroy
  has_many :suggestion_votes, dependent: :destroy

  validates :name, presence: true, length: { maximum: 120 }
  validates :comment, presence: true, length: {maximum: 1200 }

end
