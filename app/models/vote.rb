class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference
  belongs_to :comment

  after_create  :cascading_save_vote
  around_update  :cascading_update_vote

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :comment_id, presence: true
  validates :value, presence: true, inclusion: { in: 0..1 }
  validates_uniqueness_of :user_id, :scope => [:comment_id]
  validate :not_best_comment
  validate :not_user_comment

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def to_user_name
    User.select( :name ).find( self.user_id ).name
  end

  def comment_short
    Comment.select( :content_1, :user_id ).find( self.comment_id )
  end

  def reference_title
    Reference.select( :title_fr ).find( self.reference_id ).title_fr
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

  def not_best_comment
    best_comment = BestComment.find_by_comment_id(self.comment_id)
    if best_comment
      errors.add(:comment_id, "The comment is the best and can't be voted")
    end
  end

  def not_user_comment
    if self.comment.user_id == self.user_id
      errors.add(:user_id, "The comment is owned by the user")
    end
  end

  private

  def cascading_save_vote
    case self.value
      when 1
        Comment.increment_counter(:votes_plus, self.comment_id)
        Comment.increment_counter(:balance, self.comment_id)
      when 0
        Comment.increment_counter(:votes_minus, self.comment_id)
        Comment.decrement_counter(:balance, self.comment_id)
    end
    Reference.increment_counter(:nb_votes, self.reference_id)
    Timeline.increment_counter(:nb_votes, self.timeline_id)
  end

  def cascading_update_vote
    value = self.value_was
    yield
    if value != self.value
      case self.value
        when 1
          Comment.decrement_counter( :votes_minus, self.comment_id)
          Comment.increment_counter( :votes_plus, self.comment_id)
          Comment.update_counters(self.comment_id, balance: 2 )
        when 0
          Comment.decrement_counter(:votes_plus, self.comment_id)
          Comment.increment_counter(:votes_minus, self.comment_id)
          Comment.update_counters(self.comment_id, balance: -2 )
      end
    end
  end
end
