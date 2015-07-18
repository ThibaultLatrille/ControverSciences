class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference
  belongs_to :comment

  after_create  :cascading_save_vote
  after_destroy  :cascading_destroy_vote

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :comment_id, presence: true
  validates :field, presence: true, inclusion: { in: 0..7 }
  validates_uniqueness_of :user_id, :scope => [:reference_id, :field]
  validate :not_user_comment

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def comment_short
    Comment.select( :id, :user_id ).find( self.comment_id )
  end

  def reference_title
    Reference.select( :title ).find( self.reference_id ).title
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

  def not_user_comment
    comment = Comment.select( :user_id).find( self.comment_id )
    if comment.user_id == self.user_id
      errors.add(:user_id, "The comment is owned by the user")
    end
  end

  private

  def cascading_save_vote
    Comment.increment_counter( "f_#{self.field}_balance".to_sym, self.comment_id )
    Reference.increment_counter( :nb_votes, self.reference_id )
  end

  def cascading_destroy_vote
    Comment.decrement_counter( "f_#{self.field}_balance".to_sym, self.comment_id )
    Reference.decrement_counter( :nb_votes, self.reference_id )
  end
end
