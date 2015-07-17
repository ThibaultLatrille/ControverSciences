class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :summary
  
  after_create  :cascading_save_credit
  after_destroy  :cascading_destroy_credit

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :summary_id, presence: true
  validates_uniqueness_of :user_id, :scope => :timeline_id
  validate :not_user_summary

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def summary_short
    Summary.select( :id, :content, :user_id ).find( self.summary_id )
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

  def not_user_summary
    summary = Summary.select( :user_id).find( self.summary_id )
    if summary.user_id == self.user_id
      errors.add(:user_id, "The summary is owned by the user")
    end
  end

  private

  def cascading_destroy_credit
    Summary.decrement_counter(:balance, self.summary_id )
  end

  def cascading_save_credit
    Summary.increment_counter(:balance, self.summary_id)
  end
end
