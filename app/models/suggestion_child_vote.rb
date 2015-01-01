class SuggestionChildVote < ActiveRecord::Base
  belongs_to :suggestion_child

  validates :ip, presence: true
  validates :suggestion_child_id, presence: true

  after_create  :cascading_save_vote

  private

  def cascading_save_vote
    if self.value == true
      SuggestionChild.update_counters(self.suggestion_child_id, plus: 1, balance: 1 )
    else
      SuggestionChild.update_counters(self.suggestion_child_id, minus: 1, balance: -1 )
    end
  end
end
