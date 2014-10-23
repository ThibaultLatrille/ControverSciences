class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference
  belongs_to :comment

  after_create  :cascading_save_vote

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :comment_id, presence: true
  validates :value, presence: true
  validates :field, presence: true
  validates_uniqueness_of :user_id, :scope => [:reference_id, :field, :value]
  validates_uniqueness_of :user_id, :scope => [:comment_id, :value]


  private

  def cascading_save_vote
    if self.value == 1
      Comment.increment_counter(:votes_plus, self.comment_id)
      Comment.increment_counter(:rank, self.comment_id)
    elsif self.value == 0
      Comment.increment_counter(:votes_minus, self.comment_id)
      Comment.decrement_counter(:rank, self.comment_id)
    end
    most = Comment.where(reference_id: self.reference_id, field: self.field).order(rank: :desc).first
    if self.comment.id == most.id
      self.comment.reference.displayed_comment( self.comment )
    end
    Reference.increment_counter(:nb_votes, self.reference_id)
    Timeline.increment_counter(:nb_votes, self.timeline_id)
  end
end
