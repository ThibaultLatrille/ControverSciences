class Notification < ApplicationRecord
  attr_accessor :ids

  belongs_to :user
  belongs_to :timeline
  belongs_to :like
  belongs_to :reference
  belongs_to :summary
  belongs_to :comment
  belongs_to :suggestion
  belongs_to :suggestion_child
  belongs_to :frame
end
