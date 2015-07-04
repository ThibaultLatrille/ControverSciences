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
  has_many :notification_summary_selection_wins, dependent: :destroy
  has_many :notification_summary_selection_losses, dependent: :destroy
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
        # will remove from the output HTML tags inputted by user
        filter_html: true,
        # will insert <br /> tags in paragraphs where are newlines
        # (ignored by default)
        hard_wrap: true,
        # hash for extra link options, for example 'nofollow'
        link_attributes: {rel: 'nofollow'},
        # more
        # will remove <img> tags from output
        no_images: true,
        # will remove <a> tags from output
        # no_links: true
        # will remove <style> tags from output
        no_styles: true,
        # generate links for only safe protocols
        safe_links_only: true
        # and more ... (prettify, with_toc_data, xhtml)
    }

    renderer = HTMLlinks.new(render_options)
    renderer.links = []
    if Rails.env.production?
      renderer.ref_url = "http://www.controversciences.org/references/"
    else
      renderer.ref_url = "http://127.0.0.1:3000/references/"
    end

    extensions = {
        #will parse links without need of enclosing them
        autolink: true,
        # blocks delimited with 3 ` or ~ will be considered as code block.
        # No need to indent.  You can provide language name too.
        # ```ruby
        # block of code
        # ```
        #fenced_code_blocks: true,
        # will ignore standard require for empty lines surrounding HTML blocks
        lax_spacing: true,
        # will not generate emphasis inside of words, for example no_emph_no
        no_intra_emphasis: true,
        # will parse strikethrough from ~~, for example: ~~bad~~
        strikethrough: true,
        # will parse superscript after ^, you can wrap superscript in ()
        superscript: true
        # will require a space after # in defining headers
        # space_after_headers: true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.markdown = redcarpet.render(self.content)
    self.caption_markdown = redcarpet.render(self.caption)
    renderer.links
  end

  def save_with_markdown
    links = self.to_markdown
    if self.save
      reference_ids = Reference.where(timeline_id: self.id).pluck(:id)
      links.each do |link|
        if reference_ids.include? link
          SummaryLink.create({summary_id: self.id, user_id: self.user_id,
                              reference_id: link, timeline_id: self.id})
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
      NotificationSummarySelectionLoss.create(user_id: best_summary.user_id,
                                              summary_id: best_summary.summary_id)
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
      NotificationSummarySelectionWin.create(user_id: self.user_id, summary_id: self.id)
    else
      SummaryBest.create(user_id: self.user_id,
                         summary_id: self.id, timeline_id: self.timeline_id)
    end
    self.update_columns(best: true)
  end

  def refill_best_summary
    best_summary = SummaryBest.find_by(timeline_id: self.timeline_id)
    unless best_summary
      most = Summary.select(:id, :timeline_id, :user_id).where(timeline_id: self.timeline_id).order(:score => :desc).first
      if most
        most.selection_update
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
          notifications = []
          Like.where(timeline_id: self.timeline_id).pluck(:user_id).each do |user_id|
            unless self.user_id == user_id
              notifications << Notification.new(user_id: user_id, timeline_id: self.timeline_id,
                                                summary_id: self.id, category: 3)
            end
          end
          Notification.import notifications
          self.update_columns( notif_generated: true)
        end
      else
        Credit.where(summary_id: self.id).destroy_all
        if self.best
          SummaryBest.where(timeline_id: self.timeline_id).destroy_all
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
    end
    Timeline.increment_counter(:nb_summaries, self.timeline_id)
    unless TimelineContributor.find_by({user_id: self.user_id, timeline_id: self.timeline_id})
      TimelineContributor.create({user_id: self.user_id, timeline_id: self.timeline_id, bool: true})
    end
  end
end
