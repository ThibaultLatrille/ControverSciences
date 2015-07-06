class Suggestion < ActiveRecord::Base
  require 'HTMLlinks'

  belongs_to :user

  has_many :suggestion_children, dependent: :destroy
  has_many :suggestion_votes, dependent: :destroy
  has_many :notification_suggestions
  has_many :notifications, dependent: :destroy

  validates :user_id, presence: true
  validates :comment, presence: true, length: {maximum: 1200 }

  before_save :save_with_markdown
  after_create  :cascading_save

  def user_name
    User.select(:name).find(self.user_id).name
  end

  private

  def save_with_markdown
    render_options = {
        filter_html: true,
        hard_wrap: true,
        link_attributes: {rel: 'nofollow'},
        no_images: true,
        no_styles: true,
        safe_links_only: true
    }
    renderer = Redcarpet::Render::HTML.new(render_options)
    extensions = {
        autolink: true,
        lax_spacing: true,
        no_intra_emphasis: true,
        strikethrough: true,
        superscript: true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    unless self.comment.empty?
      self.content_markdown = redcarpet.render(self.comment)
    end
  end

  def cascading_save
    if self.timeline_id.blank?
      notifications = []
      User.all.pluck(:id).each do |user_id|
        unless self.user_id == user_id
          notifications << Notification.new(user_id: user_id, suggestion_id: self.id,
                                            category: 7)
        end
      end
      Notification.import notifications
    end
  end
end
