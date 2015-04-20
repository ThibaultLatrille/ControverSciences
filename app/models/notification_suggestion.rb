class NotificationSuggestion < ActiveRecord::Base
  belongs_to :user
  belongs_to :suggestion
  belongs_to :suggestion_child
end
