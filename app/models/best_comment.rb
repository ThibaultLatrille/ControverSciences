class BestComment < ActiveRecord::Base
  belongs_to :user
  belongs_to :reference
  belongs_to :comment
end
