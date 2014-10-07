class Timeline < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('rank DESC') }
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 140 }
end
