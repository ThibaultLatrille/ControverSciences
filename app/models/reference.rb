class Reference < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  after_create  :cascading_save_ref

  validates :user_id, presence: true
  validates :timeline_id, presence: true

  attr_writer :current_step

  validates_presence_of :title, :title_fr, :author, :year, :doi, :journal, :if => lambda { |o| o.current_step == "metadata" }

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[doi_name metadata confirmation]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  def displayed_comment( comment )
    case comment.field
    when 1
      self.update_attributes(f_1_id: comment.id, f_1_content: comment.content, f_1_votes_plus: comment.votes_plus, f_1_votes_minus: comment.votes_minus)
    when 2
      self.update_attributes(f_2_id: comment.id, f_2_content: comment.content, f_2_votes_plus: comment.votes_plus, f_2_votes_minus: comment.votes_minus)
    when 3
      self.update_attributes(f_3_id: comment.id, f_3_content: comment.content, f_3_votes_plus: comment.votes_plus, f_3_votes_minus: comment.votes_minus)
    when 4
      self.update_attributes(f_4_id: comment.id, f_4_content: comment.content, f_4_votes_plus: comment.votes_plus, f_4_votes_minus: comment.votes_minus)
    when 5
      self.update_attributes(f_5_id: comment.id, f_5_content: comment.content, f_5_votes_plus: comment.votes_plus, f_5_votes_minus: comment.votes_minus)
    end
  end

  def field_id( field )
    case field
      when 1
        self.f_1_id
      when 2
        self.f_2_id
      when 3
        self.f_3_id
      when 4
        self.f_4_id
      when 5
        self.f_5_id
    end
  end

  private

  def cascading_save_ref
      Timeline.increment_counter(:nb_references, self.timeline_id)
      refrelation = ReferenceContributor.new({user_id: self.user_id, reference_id: self.id, bool: true})
      refrelation.save()
      Reference.increment_counter(:nb_contributors, self.id)
      if not TimelineContributor.where({user_id: self.user_id, timeline_id: self.timeline_id}).any?
        timrelation = TimelineContributor.new({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
        timrelation.save()
        Timeline.increment_counter(:nb_contributors, self.timeline_id)
      end
  end
end
