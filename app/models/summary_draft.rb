class SummaryDraft < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline

  attr_accessor :draft_id

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end
end
