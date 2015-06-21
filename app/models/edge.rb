class Edge < ActiveRecord::Base
  belongs_to :timeline
  belongs_to :user
  attr_accessor :target_ids

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :target, presence: true
  validates :weight, presence: true, inclusion: { in: 1..12 }
  validates_uniqueness_of :timeline_id, :scope => [:target]

  def value
    1
  end

end
