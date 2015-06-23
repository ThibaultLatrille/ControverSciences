class Frame < ActiveRecord::Base
  include ApplicationHelper
  require 'HTMLlinks'

  belongs_to :timeline
  belongs_to :user

  attr_accessor :binary_left, :tag_list, :binary_right

  has_many :frame_credits, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :typos, dependent: :destroy
  has_many :notification_frame_selection_wins, dependent: :destroy
  has_many :notification_frame_selection_losses, dependent: :destroy
  has_many :frame_taggings, dependent: :destroy
  has_many :tags, through: :frame_taggings

  after_create :cascading_create_frame
  before_create :to_markdown

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :name, presence: true, length: {maximum: 180}
  validates :content, length: {maximum: 2500}

  validates_uniqueness_of :user_id, :scope => :timeline_id

  def user_name
    User.select(:name).find(self.user_id).name
  end

  def timeline_name
    Timeline.select(:name).find(self.timeline_id).name
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).frames
  end

  def self.tag_counts
    Tag.select("tags.*, count(frame_taggings.tag_id) as count").
        joins(:frame_taggings).group("frame_taggings.tag_id")
  end

  def get_tag_list
    tags.map(&:name)
  end

  def set_tag_list(names)
    if !names.nil?
      list = tags_hash.keys
      self.tags = names.map do |n|
        if list.include? n
          Tag.where(name: n.strip).first_or_create!
        end
      end
    end
  end

  def my_frame_credit(user_id)
    credit = FrameCredit.select(:value).find_by( user_id: user_id, frame_id: self.id )
    if credit
      credit.value
    else
      0
    end
  end

  def to_markdown
    render_options = {
        filter_html: true,
        hard_wrap: true,
        link_attributes: {rel: 'nofollow'},
        no_images: true,
        no_styles: true,
        safe_links_only: true
    }
    renderer = RenderWithoutWrap.new(render_options)
    extensions = {
        autolink: true,
        lax_spacing: true,
        no_intra_emphasis: true,
        strikethrough: true,
        superscript: true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.content_markdown = redcarpet.render(self.content)
    self.name_markdown = redcarpet.render(self.name)
    if self.best
      tim = self.timeline
      tim.name = self.name_markdown
      tim.frame = self.content_markdown
      tim.binary = self.binary
      tim.set_tag_list(self.get_tag_list)
      tim.save
    end
  end

  def save_with_markdown
    self.to_markdown
    self.save
  end

  def selection_update(best_frame = nil)
    if best_frame
      NotificationFrameSelectionLoss.create(user_id: best_frame.user_id,
                                              frame_id: best_frame.id)
      best_frame.update_columns(best: false)
      notifications = []
      Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |user_id|
        unless self.user_id == user_id || best_frame.user_id == user_id
          notifications << Notification.new(user_id:    user_id, timeline_id: self.timeline_id,
                                            frame_id: self.id,
                                            category: 9)
        end
      end
      Notification.import notifications

      NotificationFrameSelectionWin.create(user_id: self.user_id, frame_id: self.id)
    end
    tim = self.timeline
    tim.name = self.name_markdown
    tim.frame = self.content_markdown
    tim.binary = self.binary
    tim.set_tag_list(self.get_tag_list)
    tim.save
    self.update_columns(best: true)
  end

  def refill_best_frame
    best_frame = Frame.find_by(timeline_id: self.timeline_id, best: true)
    unless best_frame
      most = Frame.where(timeline_id: self.timeline_id).order(:score => :desc).first
      if most
        most.selection_update
      end
    end
  end

  def destroy_with_counters
    tim_user_id = Timeline.select(:user_id).find(self.timeline_id ).user_id
    if self.user_id == tim_user_id
      false
    else
      self.destroy
      Timeline.decrement_counter(:nb_frames, self.timeline_id)
      if self.best
        refill_best_frame
      end
      true
    end
  end

  private

  def cascading_create_frame
    unless self.best
      notifications = []
      Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |user_id|
        unless self.user_id == user_id
          notifications << Notification.new(user_id: user_id, timeline_id: self.timeline_id,
                                            frame_id: self.id,
                                            category: 8)
        end
      end
      Notification.import notifications
    end

    Timeline.increment_counter(:nb_frames, self.timeline_id)
    unless TimelineContributor.find_by({user_id: self.user_id, timeline_id: self.timeline_id})
      TimelineContributor.create({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
    end
  end
end
