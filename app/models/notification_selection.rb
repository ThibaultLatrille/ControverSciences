class NotificationSelection < ApplicationRecord
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference
  belongs_to :frame
  belongs_to :comment
  belongs_to :summary

  after_create :increment_nb_notifs
  after_destroy :decrement_nb_notifs

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def reference_short
    Reference.select( :id, :slug, :title, :category ).find( self.reference_id )
  end

  def timeline_short
    Timeline.select( :id, :slug, :name ).find( self.timeline_id )
  end

  private

  def increment_nb_notifs
    User.increment_counter(:nb_notifs, self.user_id)
  end

  def decrement_nb_notifs
    User.decrement_counter(:nb_notifs, self.user_id)
  end

end
