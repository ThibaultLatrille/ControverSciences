class SuggestionChildVote < ActiveRecord::Base
  belongs_to :suggestion_child
  belongs_to :user

  validates :user_id, presence: true
  validates :suggestion_child_id, presence: true
  validates_uniqueness_of :user_id, :scope => [:suggestion_child_id, :value]

  after_create  :cascading_save_vote
  after_destroy  :cascading_destroy_vote

  private

  def cascading_save_vote
    if self.value == true
      SuggestionChild.update_counters(self.suggestion_child_id, plus: 1, balance: 1 )
    else
      SuggestionChild.update_counters(self.suggestion_child_id, minus: 1, balance: -1 )
    end
  end

  def cascading_destroy_vote
    if self.value == true
      SuggestionChild.update_counters(self.suggestion_child_id, plus: -1, balance: -1 )
    else
      SuggestionChild.update_counters(self.suggestion_child_id, minus: -1, balance: 1 )
    end
  end
end
