class Frame < ActiveRecord::Base
  include ApplicationHelper
  require 'HTMLlinks'

  attr_accessor :binary_left, :binary_right

  belongs_to :timeline
  belongs_to :user

  has_many :frame_credits, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :notification_selections, dependent: :destroy
  has_many :go_patches, dependent: :destroy

  before_validation :check_binary

  after_create :cascading_create_frame
  after_save :update_timeline
  before_create :to_markdown

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :name, presence: true, length: {maximum: 180}
  validates :content, length: {minimum: 180, maximum: 2500}

  validates_uniqueness_of :user_id, :scope => :timeline_id

  def user_name
    User.select(:name).find(self.user_id).name
  end

  def timeline_name
    Timeline.select(:name).find(self.timeline_id).name
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
    renderer_no_wrap = RenderWithoutWrap.new(render_options)
    renderer = Redcarpet::Render::HTML.new(render_options)
    extensions = {
        autolink: true,
        lax_spacing: true,
        no_intra_emphasis: true,
        strikethrough: true,
        superscript: true
    }
    redcarpet_no_wrap = Redcarpet::Markdown.new(renderer_no_wrap, extensions)
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.content_markdown = redcarpet.render(self.content)
    self.name_markdown = redcarpet_no_wrap.render(self.name)
  end

  def save_with_markdown
    self.to_markdown
    self.save
  end

  def selection_update(best_frame = nil)
    if best_frame
      Notification.where(timeline_id: self.timeline_id, category: 9).destroy_all

      NotificationSelection.create(user_id: best_frame.user_id, timeline_id: self.timeline_id,
                                              frame_id: best_frame.id, win: false )
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

      NotificationSelection.create(user_id: self.user_id, timeline_id: self.timeline_id,
                                           frame_id: self.id, win: true)
    end
    tim = self.timeline
    tim.update_columns(name: self.name_markdown, frame: self.content_markdown)
    tim.reset_binary(self.binary)
    self.update_columns(best: true)
  end

  def refill_best_frame
    best_frame = Frame.find_by(timeline_id: self.timeline_id, best: true)
    unless best_frame
      most = Frame.where(timeline_id: self.timeline_id).order(:balance => :desc).first
      if most
        most.selection_update
      end
    end
  end

  def update_best_frame
    most_frame = Frame.where(timeline_id: self.timeline_id).order(balance: :desc).first
    best_frame = Frame.find_by(timeline_id: self.timeline_id, best: true)
    if most_frame
      if (most_frame.id != best_frame.id) && (most_frame.balance > (best_frame.balance + 1))
        most_frame.selection_update(best_frame)
      end
    end
  end

  def destroy_with_counters
    if Frame.where(timeline_id: self.timeline_id).count == 1
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

  def content_validation
    if self.public
      if self.name && self.name.length_sub > 180
        errors.add(:name, I18n.t('errors.messages.too_long', count: 180))
      end
      if self.content && self.content.length_sub < 180
        errors.add(:frame, I18n.t('errors.messages.too_short', count: 180))
      end
      if self.content && self.content.length_sub > 2500
        errors.add(:content, I18n.t('errors.messages.too_long', count: 2500))
      end
    end
  end

  def update_timeline
    if self.best
      tim = self.timeline
      tim.update_columns(name: self.name_markdown, frame: self.content_markdown)
      if tim.binary != self.binary
        tim.reset_binary(self.binary)
      end
    end
  end

  def check_binary
    if self.binary.downcase == "non&&oui"
      self.binary = "Oui&&Non"
    end
  end

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
