class Edge < ActiveRecord::Base
  belongs_to :timeline
  belongs_to :user

  attr_accessor :value

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :target, presence: true
  validates :weight, presence: true, inclusion: { in: 1..12 }
  validates_uniqueness_of :timeline_id, :scope => [:target]

  def target_name
    Timeline.select(:name).find(self.target).name
  end

  def timeline_name
    Timeline.select(:name).find(self.timeline_id).name
  end


  def plus
    EdgeVote.where(edge_id: self.id, value: true).count
  end

  def minus
    EdgeVote.where(edge_id: self.id, value: false).count
  end

  def reverse
    if self.reversible
      Edge.find_by( timeline_id: self.target )
    end
  end
end
