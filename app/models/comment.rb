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

  private

  def cascading_save_comment
      reference = self.reference
      if self.field == 1
        if reference.f_1_id.nil?
          reference.update_attributes(f_1_id: self.id, f_1_content: self.content, f_1_votes_plus: self.votes_plus, f_1_votes_minus: self.votes_minus)
        end
      elsif self.field == 2
        if reference.f_2_id.nil?
          reference.update_attributes(f_2_id: self.id, f_2_content: self.content, f_2_votes_plus: self.votes_plus, f_2_votes_minus: self.votes_minus)
        end
      elsif self.field == 3
        if reference.f_3_id.nil?
          reference.update_attributes(f_3_id: self.id, f_3_content: self.content, f_3_votes_plus: self.votes_plus, f_3_votes_minus: self.votes_minus)
        end
      elsif self.field == 4
        if reference.f_4_id.nil?
          reference.update_attributes(f_4_id: self.id, f_4_content: self.content, f_4_votes_plus: self.votes_plus, f_4_votes_minus: self.votes_minus)
        end
      elsif self.field == 5
        if reference.f_5_id.nil?
          reference.update_attributes(f_5_id: self.id, f_5_content: self.content, f_5_votes_plus: self.votes_plus, f_5_votes_minus: self.votes_minus)
        end
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