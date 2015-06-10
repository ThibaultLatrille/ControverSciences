class Notification < ActiveRecord::Base
  attr_accessor :timeline_ids
  attr_accessor :reference_ids
  attr_accessor :comment_ids
  attr_accessor :sel_comment_ids
  attr_accessor :summary_ids
  attr_accessor :sel_summary_ids
  attr_accessor :suggestion_ids

  belongs_to :user
  belongs_to :timeline
  belongs_to :like
  belongs_to :reference
  belongs_to :summary
  belongs_to :comment
  belongs_to :suggestion

end
