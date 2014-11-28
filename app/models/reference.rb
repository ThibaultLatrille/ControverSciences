class Reference < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  has_many :links
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :reference_contributors, dependent: :destroy

  has_many :following_references, dependent: :destroy
  has_many :notification_references, dependent: :destroy

  has_one :best_comment, dependent: :destroy

  after_create  :cascading_save_ref

  validates :user_id, presence: true
  validates :timeline_id, presence: true

  attr_writer :current_step

  validates_presence_of :title, :title_fr, :author, :year, :doi, :url, :journal, :if => lambda { |o| o.current_step == "metadata" }
  validates_uniqueness_of :timeline_id, :scope => [:doi], :if => lambda { |o| o.current_step == "metadata" }

  def user_name
    User.select( :name ).find( self.user_id ).name
  end

  def timeline_name
    Timeline.select( :name ).find( self.timeline_id ).name
  end

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

  def create_notifications
    user_ids = FollowingTimeline.where( timeline_id: self.timeline_id ).pluck( :user_id )
    notifications = []
    user_ids.each do |user_id|
      notifications << NotificationReference.new( user_id: user_id, reference_id: self.id )
    end
    NotificationReference.import notifications
  end

  def destroy_with_counters
    nb_comments = self.comments.count
    nb_votes = self.votes.count
    Timeline.decrement_counter( :nb_references , self.timeline_id)
    Timeline.update_counters( self.timeline_id, nb_edits: -nb_comments )
    Timeline.update_counters( self.timeline_id, votes: -nb_votes )
    self.destroy
  end

  private

  def cascading_save_ref
    self.create_notifications
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
