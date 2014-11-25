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
  validates :value, presence: true, inclusion: { in: 0..12 }
  validates_uniqueness_of :user_id, :scope => [:comment_id]
  validate :not_user_comment
  validate :not_excede_value

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def to_user_name
    User.select( :name ).find( self.user_id ).name
  end

  def comment_short
    Comment.select( :f_1_content, :user_id ).find( self.comment_id )
  end

  def reference_title
    Reference.select( :title_fr ).find( self.reference_id ).title_fr
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

  def sum
    Vote.where( user_id: self.user_id, reference_id: self.reference_id).sum( :value )
  end

  def not_user_comment
    comment = Comment.select( :user_id).find( self.comment_id )
    if comment.user_id == self.user_id
      errors.add(:user_id, "The comment is owned by the user")
    end
  end

  def not_excede_value
    sum = Vote.where( user_id: self.user_id,
                reference_id: self.reference_id ).sum( :value )
    sum += self.value
    if sum > 12
      errors.add(:value, "The value exceded the permitted amount")
    end
  end

  def destroy_with_counters
    Comment.update_counters(self.comment_id, balance: -self.value )
    Reference.update_counters(self.reference_id, nb_votes: -self.value )
    Timeline.update_counters(self.timeline_id, nb_votes: -self.value )
    self.destroy
  end

  private

  def cascading_save_vote
    Comment.update_counters(self.comment_id, balance: self.value )
    Reference.update_counters(self.reference_id, nb_votes: self.value )
    Timeline.update_counters(self.timeline_id, nb_votes: self.value )
  end

  def cascading_update_vote
    value = self.value_was
    yield
    if value != self.value
      diff = self.value - value
      Comment.update_counters(self.comment_id, balance: diff )
      Reference.update_counters(self.reference_id, nb_votes: diff )
      Timeline.update_counters(self.timeline_id, nb_votes: diff )
    end
  end
end
