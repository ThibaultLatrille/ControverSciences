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

  def my_vote( user_id )
    vote = EdgeVote.find_by( timeline_id: self.timeline_id, target: self.target,
                      user_id: user_id )
    unless vote
      vote = EdgeVote.find_by( timeline_id: self.target, target: self.timeline_id,
                        user_id: user_id )
    end
    vote
  end

  def my_vote_key( user_id, timeline_id)
    edge_vote = my_vote( user_id )
    if edge_vote.blank?
      4
    else
      if edge_vote.reversible
        2
      else
        if edge_vote.timeline_id == timeline_id
          0
        else
          1
        end
      end
    end
  end

  def reverse
    if self.reversible
      Edge.find_by( timeline_id: self.target )
    end
  end
end
