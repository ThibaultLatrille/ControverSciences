class Question < ActiveRecord::Base
  belongs_to :user

  validates :score, presence: true
  validates_uniqueness_of :score

  before_save :to_markdown

  def to_markdown
    render_options = {
        filter_html:     true,
        hard_wrap:       true,
        link_attributes: { rel: 'nofollow' },
        no_images: true,
        no_styles: true,
        safe_links_only: true
    }
    renderer = RenderWithoutWrap.new(render_options)
    extensions = {
        autolink:           true,
        lax_spacing:        true,
        no_intra_emphasis:  true,
        strikethrough:      true,
        superscript:        true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    unless self.content.blank?
      self.content_markdown = redcarpet.render(self.content)
    end
    unless self.title.blank?
      self.title_markdown = redcarpet.render(self.title)
    end
  end
end
