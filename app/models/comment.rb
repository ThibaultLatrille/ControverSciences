class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  belongs_to :reference
  has_many :votes, dependent: :destroy

  after_create :cascading_save_comment

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :reference_id, presence: true
  validates :content, presence: true
  validates :field, presence: true
  validates_uniqueness_of :user_id, :scope => [:reference_id, :field]

  private

  def cascading_save_comment
      reference = self.reference
      if reference.field_id( self.field ).nil?
        reference.displayed_comment( self )
      end
      Reference.increment_counter(:nb_edits, self.reference_id)
      Timeline.increment_counter(:nb_edits, self.timeline_id)
      if not TimelineContributor.where({user_id: self.user_id, timeline_id: self.timeline_id}).any?
        timrelation=TimelineContributor.new({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
        timrelation.save()
        Timeline.increment_counter(:nb_contributors, self.timeline_id)
      end
      if not ReferenceContributor.where({user_id: self.user_id, reference_id: self.reference_id}).any?
        refrelation=ReferenceContributor.new({user_id: self.user_id, reference_id: self.reference_id, bool: true})
        refrelation.save()
        Reference.increment_counter(:nb_contributors, self.reference_id)
      end
  end
end