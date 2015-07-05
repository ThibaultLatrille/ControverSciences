class NotificationSuggestion < ActiveRecord::Base
  belongs_to :user
  belongs_to :suggestion
  belongs_to :suggestion_child

  after_create :increment_nb_notifs
  after_destroy :decrement_nb_notifs

  private

  def increment_nb_notifs
    User.increment_counter(:nb_notifs, self.suggestion.user_id)
  end

  def decrement_nb_notifs
    User.decrement_counter(:nb_notifs, self.suggestion.user_id)
  end
end
