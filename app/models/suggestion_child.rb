class SuggestionChild < ActiveRecord::Base
  require 'HTMLlinks'

  belongs_to :user
  belongs_to :suggestion
  has_many :suggestion_child_votes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :locations, dependent: :destroy

  validates :suggestion_id, presence: true
  validates :comment, presence: true, length: {maximum: 4000, minimum: 40}

  before_save :save_with_markdown
  after_create  :cascading_save
  after_destroy :cascading_destroy

  def user_name
    if self.user_id
      User.select(:name).find(self.user_id).name
    else
      self.name
    end
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
    Suggestion.update_counters(self.suggestion_id, children: 1 )
    user_ids = SuggestionChild.where( suggestion_id: self.suggestion_id).pluck( :user_id )
    user_ids << Suggestion.select(:user_id).find(self.suggestion_id).user_id
    notifications = []
    user_ids.uniq.each do |author_id|
      if self.user_id != author_id
        notifications << Notification.new(user_id: user_id,
                                          suggestion_id: self.suggestion_id,
                                          suggestion_child_id: self.id,
                                          category: 11)
      end
    end
    Notification.import notifications
  end

  def cascading_destroy
    Suggestion.update_counters(self.suggestion_id, children: -1 )
  end
end
