class Timeline < ActiveRecord::Base
  belongs_to :user
  has_many :references, dependent: :destroy

  default_scope -> { order('rank DESC') }

  after_create :cascading_save_timeline

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 180 }

  def star_percent( value )
    case value
      when 1
        self.star_1*100/self.nb_references
      when 2
        self.star_2*100/self.nb_references
      when 3
        self.star_3*100/self.nb_references
      when 4
        self.star_4*100/self.nb_references
      when 5
        self.star_5*100/self.nb_references
    end
  end

  private

  def cascading_save_timeline
      timrelation=TimelineContributor.new({user_id: self.user_id, timeline_id: self.id, bool: true})
      timrelation.save()
      Timeline.increment_counter(:nb_contributors, self.id)
  end
end
