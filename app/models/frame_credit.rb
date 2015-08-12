class FrameCredit < ActiveRecord::Base
  belongs_to :timeline
  belongs_to :user
  belongs_to :frame

  after_create  :cascading_save_credit
  after_destroy  :cascading_destroy_credit

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :frame_id, presence: true
  validates_uniqueness_of :user_id, :scope => :timeline_id
  validate :not_user_frame

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def frame_short
    Frame.select( :id, :content, :user_id ).find( self.frame_id )
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

  def not_user_frame
    frame = Frame.select( :user_id).find( self.frame_id )
    if frame.user_id == self.user_id
      errors.add(:user_id, "The frame is owned by the user")
    end
  end

  def update_frame
    self.frame.update_best_frame
  end

  private

  def cascading_destroy_credit
    Frame.decrement_counter(:balance, self.frame_id )
  end

  def cascading_save_credit
    Frame.increment_counter(:balance, self.frame_id )
  end
end
