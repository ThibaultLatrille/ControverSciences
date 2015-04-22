class NotificationSelectionLoss < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def reference
    Reference.select( :id, :title, :article ).find( Comment.select( :reference_id ).find( self.comment_id ).reference_id )
  end

  def timeline
    Timeline.select( :id, :name ).find( Comment.select( :timeline_id ).find( self.comment_id ).timeline_id )
  end
end
