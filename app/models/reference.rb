class Reference < ActiveRecord::Base
  belongs_to :user
  belongs_to :timeline
  has_many :links, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :reference_contributors, dependent: :destroy

  after_create  :cascading_save_ref

  validates :user_id, presence: true
  validates :timeline_id, presence: true

  attr_writer :current_step

  validates_presence_of :title, :title_fr, :author, :year, :doi, :url, :journal, :if => lambda { |o| o.current_step == "metadata" }
  validates_uniqueness_of :timeline_id, :scope => [:doi], :if => lambda { |o| o.current_step == "metadata" }

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

  def displayed_comment( comment, best_comment = nil )
    field = comment.field
    if best_comment
      NotificationSelectionLoss.create( user_id: best_comment.user_id,
                                        comment_id: best_comment.comment_id)
      User.increment_counter( :notifications_loss, best_comment.user_id)
      Comment.find( best_comment.comment_id ).update_attributes( best: false )
      best_comment.update_attributes( user_id: comment.user_id, comment_id: comment.id )
      NotificationSelectionWin.create( user_id: comment.user_id, comment_id: comment.id)
      User.increment_counter( :notifications_win, comment.user_id )
      self.selection_notifications( field )
    else
      BestComment.create( user_id: comment.user_id, reference_id: comment.reference_id,
                                     comment_id: comment.id, field: comment.field )
    end
    self.update_attributes("f_#{field}_content".to_sym => comment.content_markdown)
    comment.update_attributes( best: true)
  end

  def create_notifications
    user_ids = FollowingTimeline.where( timeline_id: self.timeline_id ).pluck( :user_id )
    notifications = []
    user_ids.each do |user_id|
      notifications << NotificationReference.new( user_id: user_id, reference_id: self.id )
    end
    NotificationReference.import notifications
    User.increment_counter( :notifications_reference, user_ids)
  end

  def selection_notifications( field )
    ids = Comment.where( reference_id: self.id, field: field ).pluck(:id, :user_id )
    notifications = []
    user_ids = []
    comment_ids = []
    ids.each do |comment_id, user_id|
      user_ids << user_id
      comment_ids << comment_id
      notifications << NotificationSelection.new( user_id: user_id, comment_id: comment_id )
    end
    NotificationSelection.import notifications
    User.increment_counter( :notifications_selection, user_ids)
    Comment.where(id: comment_ids).update_all(votes_plus: 0, votes_minus: 0, balance: 0 )
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
