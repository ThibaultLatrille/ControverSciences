class Suggestion < ActiveRecord::Base
  belongs_to :user

  attr_accessor :debate

  has_many :suggestion_children, dependent: :destroy
  has_many :suggestion_votes, dependent: :destroy
  has_many :notification_suggestions

  validates :name, presence: true, length: { maximum: 120 }
  validates :comment, presence: true, length: {maximum: 1200 }

  after_destroy :cascading_destroy

  private

  def cascading_destroy
    if self.timeline_id
      tim = Timeline.find( self.timeline_id )
      if tim
        tim.update_columns( debate: false )
      end
    end
  end
end
