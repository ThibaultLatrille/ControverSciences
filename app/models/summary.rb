class Summary < ActiveRecord::Base
  require 'HTMLlinks'

  attr_accessor :delete_picture, :has_picture

  belongs_to :user
  belongs_to :timeline

  has_many :credits, dependent: :destroy
  has_many :summary_links, dependent: :destroy

  # WTF is that dependent: :destroy doing here
  has_one :summary_best, dependent: :destroy

  has_many :notifications, dependent: :destroy
  has_many :notification_selections, dependent: :destroy
  has_many :typos, dependent: :destroy

  after_create :cascading_save_summary

  around_update :updating_with_public

  validates :user_id, presence: true
  validates :timeline_id, presence: true
  validates :content, presence: true, length: {maximum: 12500}

  validates_uniqueness_of :user_id, :scope => :timeline_id

  def user_name
    User.select(:name).find(self.user_id).name
  end

  def timeline_name
    Timeline.select(:name).find(self.timeline_id).name
  end

  def picture?
    self.figure_id ? true : false
  end

  def picture_url
    if self.figure_id
      Figure.select(:id, :picture, :user_id).find(self.figure_id).picture_url
    else
      nil
    end
  end

  def my_credit(user_id)
    credit = Credit.select(:value).find_by(user_id: user_id, summary_id: self.id)
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

    renderer = HTMLlinks.new(render_options)
    renderer.links = {}
    renderer.counter = 1
    if Rails.env.production?
      renderer.root_url = "https://controversciences.org"
    else
      renderer.root_url = "http://127.0.0.1:3000"
    end

    extensions = {
        autolink: true,
        lax_spacing: true,
        no_intra_emphasis: true,
        strikethrough: true,
        # will parse superscript after ^, you can wrap superscript in ()
        superscript: true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.markdown = redcarpet.render(self.content)
    self.caption_markdown = redcarpet.render(self.caption)
    renderer.links
  end

  def save_with_markdown
    links = self.to_markdown
    if self.save
      reference_ids = Reference.where(timeline_id: self.timeline_id).pluck(:id)
      links.each do |link,value|
        if reference_ids.include? link
          SummaryLink.create({summary_id: self.id, user_id: self.user_id, count: value,
                              reference_id: link, timeline_id: self.timeline_id})
        end
      end
      true
    else
      false
    end
  end

  def update_with_markdown
    SummaryLink.where(user_id: user_id, summary_id: id).destroy_all
    save_with_markdown
  end

  def selection_update(best_summary = nil)
    if best_summary
      Notification.where(timeline_id: self.timeline_id, category: 4).destroy_all

      NotificationSelection.create(user_id: best_summary.user_id, timeline_id: self.timeline_id,
                                              summary_id: best_summary.summary_id, win: false)
      notifications = []
      Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |user_id|
        unless self.user_id == user_id || best_summary.user_id == user_id
          notifications << Notification.new(user_id:    user_id, timeline_id: self.timeline_id,
                                            summary_id: self.id, category: 4)
        end
      end
      Notification.import notifications
      Summary.where(id: best_summary.summary_id).update_all(best: false)
      best_summary.update_attributes(user_id: self.user_id, summary_id: self.id)
      NotificationSelection.create(user_id: self.user_id,  timeline_id: self.timeline_id,
                                   summary_id: self.id, win: true)
    else
      SummaryBest.create(user_id: self.user_id,
                         summary_id: self.id, timeline_id: self.timeline_id)
    end
    self.update_columns(best: true)
  end

  def refill_best_summary
    best_summary = SummaryBest.find_by(timeline_id: self.timeline_id)
    unless best_summary
      most = Summary.select(:id, :timeline_id, :user_id).where(timeline_id: self.timeline_id).order(:balance => :desc).first
      if most
        most.selection_update
      end
    end
  end

  def update_best_summary
    most         = Summary.where(timeline_id: self.timeline_id, public: true).order(balance: :desc).first
    best_summary = SummaryBest.find_by(timeline_id: self.timeline_id)
    if most
      if (most.id != best_summary.summary_id) && (most.balance > (best_summary.balance + 1))
        most.selection_update(best_summary)
      end
    end
  end

  def destroy_with_counters
    Timeline.decrement_counter(:nb_summaries, self.timeline_id)
    self.destroy
    refill_best_summary
  end

  private

  def updating_with_public
    public = self.public_was
    yield
    if public != self.public
      if self.public
        test = SummaryBest.where(timeline_id: self.timeline_id).nil?
        unless test
          self.selection_update
        end
        unless self.notif_generated
          Notification.where( timeline_id: self.timeline_id,
                           summary_id: self.id, category: 3).destroy_all
          notifications = []
          Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |user_id|
            unless self.user_id == user_id
              notifications << Notification.new(user_id: user_id, timeline_id: self.timeline_id,
                                                summary_id: self.id, category: 3)
            end
          end
          Notification.import notifications
          self.update_columns( notif_generated: true)
          Timeline.increment_counter(:nb_summaries, self.timeline_id)
        end
      else
        Credit.where(summary_id: self.id).destroy_all
        Timeline.decrement_counter(:nb_summaries, self.timeline_id)
        self.update_columns( notif_generated: false)
        if self.best
          SummaryBest.where(timeline_id: self.timeline_id).destroy_all
          refill_best_summary
        end
      end
    end
  end

  def cascading_save_summary
    if self.public
      best_summary = SummaryBest.find_by(timeline_id: self.timeline_id)
      unless best_summary
        self.selection_update
      end
      notifications = []
      Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |user_id|
        unless self.user_id == user_id
          notifications << Notification.new(user_id: user_id, timeline_id: self.timeline_id,
                                            summary_id: self.id, category: 3)
        end
      end
      Notification.import notifications
      self.update_columns( notif_generated: true)
      Timeline.increment_counter(:nb_summaries, self.timeline_id)
    end
    unless TimelineContributor.find_by({user_id: self.user_id, timeline_id: self.timeline_id})
      TimelineContributor.create({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
    end
  end
end
