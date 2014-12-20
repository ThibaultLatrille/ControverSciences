class Credit < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :summary
  
  after_create  :cascading_save_credit
  around_update  :cascading_update_credit

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :summary_id, presence: true
  validates :value, presence: true, inclusion: { in: 1..12 }
  validates_uniqueness_of :user_id, :scope => :summary_id
  validate :not_user_summary
  validate :not_excede_value

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def summary_short
    Summary.select( :id, :content, :user_id ).find( self.summary_id )
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

  def sum
    Credit.where( user_id: self.user_id, timeline_id: self.timeline_id).sum( :value )
  end

  def not_user_summary
    summary = Summary.select( :user_id).find( self.summary_id )
    if summary.user_id == self.user_id
      errors.add(:user_id, "The summary is owned by the user")
    end
  end

  def not_excede_value
    sum = Credit.where( user_id: self.user_id,
                        timeline_id: self.timeline_id ).where.not( id: self.id ).sum( :value )
    sum += self.value
    if sum > 12
      errors.add(:value, "The value exceded the permitted amount")
    end
  end

  def destroy_with_counters
    Summary.update_counters( self.summary_id, balance: -self.value )
    self.destroy
  end

  private

  def cascading_save_credit
    Summary.update_counters( self.summary_id, balance: self.value )
  end

  def cascading_update_credit
    value = self.value_was
    yield
    if value != self.value
      diff = self.value - value
      Summary.update_counters(self.summary_id, balance: diff )
    end
  end
end
