class SuggestionChild < ActiveRecord::Base
  belongs_to :user
  belongs_to :suggestion
  has_many :suggestion_child_votes, dependent: :destroy
  has_one :notification_suggestion, dependent: :destroy

  validates :suggestion_id, presence: true
  validates :name, presence: true, length: { maximum: 120 }
  validates :comment, presence: true, length: {maximum: 1200 }

  after_create  :cascading_save
  after_destroy :cascading_destroy
  private

  def cascading_save
    Suggestion.update_counters(self.suggestion_id, children: 1 )
    suggestion = self.suggestion
    NotificationSuggestion.create(user_id: suggestion.user_id,
                                  suggestion_id: suggestion.id,
                                  suggestion_child_id: self.id) if suggestion.user_id
  end

  def cascading_destroy
    Suggestion.update_counters(self.suggestion_id, children: -1 )
  end
end
