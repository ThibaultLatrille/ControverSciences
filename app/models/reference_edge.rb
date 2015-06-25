class ReferenceEdge < ActiveRecord::Base
  belongs_to :reference
  belongs_to :user

  attr_accessor :value

  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates :timeline_id, presence: true
  validates :target, presence: true
  validates :weight, presence: true, inclusion: { in: 1..12 }
  validates_uniqueness_of :reference_id, :scope => [:target]

  def target_name
    Reference.select(:title).find(self.target).title
  end

  def reference_name
    Reference.select(:title).find(self.reference_id).title
  end

  def my_reference_vote( user_id )
    reference_vote = ReferenceEdgeVote.find_by( reference_id: self.reference_id, target: self.target,
                      user_id: user_id )
    unless reference_vote
      reference_vote = ReferenceEdgeVote.find_by( reference_id: self.target, target: self.reference_id,
                        user_id: user_id )
    end
    reference_vote
  end

  def my_reference_vote_key( user_id, reference_id)
    edge_reference_vote = my_reference_vote( user_id )
    if edge_reference_vote.blank?
      4
    else
      if edge_reference_vote.reversible
        2
      else
        if edge_reference_vote.reference_id == reference_id
          0
        else
          1
        end
      end
    end
  end

  def reverse
    if self.reversible
      ReferenceEdge.find_by( reference_id: self.target )
    end
  end
end
