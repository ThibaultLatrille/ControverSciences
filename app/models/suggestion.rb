class Suggestion < ActiveRecord::Base
  belongs_to :user

  attr_accessor :debate

  has_many :suggestion_children, dependent: :destroy
  has_many :suggestion_votes, dependent: :destroy
  has_many :notification_suggestions

  validates :name, presence: true, length: { maximum: 120 }
  validates :comment, presence: true, length: {maximum: 1200 }

  after_destroy :cascading_destroy
  before_save :save_with_markdown

  private

  def save_with_markdown
    render_options = {
        filter_html:     true,
        hard_wrap:       true,
        link_attributes: { rel: 'nofollow' },
        no_images: true,
        no_styles: true,
        safe_links_only: true
    }
    renderer = Redcarpet::Render::HTML.new( render_options )
    extensions = {
        autolink:           true,
        lax_spacing:        true,
        no_intra_emphasis:  true,
        strikethrough:      true,
        superscript:        true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    unless self.comment.empty?
      self.content_markdown = redcarpet.render(self.comment)
    end
  end

  def cascading_destroy
    if self.timeline_id
      tim = Timeline.find( self.timeline_id )
      if tim
        tim.update_columns( debate: false )
      end
    end
  end
end
