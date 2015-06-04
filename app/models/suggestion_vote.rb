class SuggestionVote < ActiveRecord::Base
  belongs_to :suggestion
  belongs_to :user

  validates :user_id, presence: true
  validates :suggestion_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:suggestion_id, :value]

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
