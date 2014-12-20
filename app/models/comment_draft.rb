class CommentDraft < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference

  attr_accessor :draft_id

  def reference_title
    Reference.select( :title_fr ).find( self.reference_id ).title_fr
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end
end
