class NotificationSelectionLoss < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  after_create :increment_nb_notifs
  after_destroy :decrement_nb_notifs

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def reference
    Reference.select( :id, :title, :article ).find( Comment.select( :reference_id ).find( self.comment_id ).reference_id )
  end

  def timeline
    Timeline.select( :id, :name ).find( Comment.select( :timeline_id ).find( self.comment_id ).timeline_id )
  end

  private

  def increment_nb_notifs
    User.increment_counter(:nb_notifs, self.user_id)
  end

  def decrement_nb_notifs
    User.decrement_counter(:nb_notifs, self.user_id)
  end

end
