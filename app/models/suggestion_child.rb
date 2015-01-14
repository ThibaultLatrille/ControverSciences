class SuggestionChild < ActiveRecord::Base
  belongs_to :user
  belongs_to :suggestion
  has_many :suggestion_child_votes, dependent: :destroy

  validates :suggestion_id, presence: true
  validates :name, presence: true, length: { maximum: 120 }
  validates :comment, presence: true, length: {maximum: 1200 }

end
