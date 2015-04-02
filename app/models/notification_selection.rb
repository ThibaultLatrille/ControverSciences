class NotificationSelection < ActiveRecord::Base
  belongs_to :user

  def author
    User.select( :id, :name ).find( Comment.select( :user_id ).find( self.new_comment_id ).user_id )
  end

  def reference
    Reference.select( :id, :title ).find( Comment.select( :reference_id ).find( self.new_comment_id ).reference_id )
  end

  def timeline
    Timeline.select( :id, :name ).find( Comment.select( :timeline_id ).find( self.new_comment_id ).timeline_id )
  end
end
