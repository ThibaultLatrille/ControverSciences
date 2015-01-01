class SuggestionChild < ActiveRecord::Base
  belongs_to :user
  belongs_to :suggestion

  validates :suggestion_id, presence: true
  validates :name, presence: true, length: { maximum: 120 }
  validates :comment, presence: true, length: {maximum: 480 }

end
