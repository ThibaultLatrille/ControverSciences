class NotificationSummarySelectionLoss < ActiveRecord::Base
  belongs_to :user
  belongs_to :summary

  after_create :increment_nb_notifs
  after_destroy :decrement_nb_notifs

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def timeline
    Timeline.select( :id, :name ).find( Summary.select( :timeline_id ).find( self.summary_id ).timeline_id )
  end

  private

  def increment_nb_notifs
    User.increment_counter(:nb_notifs, self.user_id)
  end

  def decrement_nb_notifs
    User.decrement_counter(:nb_notifs, self.user_id)
  end
end
