class SuggestionVote < ActiveRecord::Base
  belongs_to :suggestion

  validates :ip, presence: true
  validates :suggestion_id, presence: true

  after_create  :cascading_save_vote

  private

  def cascading_save_vote
    if self.value == true
      Suggestion.update_counters(self.suggestion_id, plus: 1, balance: 1 )
    else
      Suggestion.update_counters(self.suggestion_id, minus: 1, balance: -1 )
    end
  end
end
