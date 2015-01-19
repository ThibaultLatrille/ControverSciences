class SummaryDraft < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline

  attr_accessor :draft_id

  validates_uniqueness_of :user_id, :scope => :timeline_id

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end
end
