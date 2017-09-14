class UserDetail < ApplicationRecord

  belongs_to :user
  attr_accessor :delete_picture, :has_picture

  validates :user_id, presence: true
  validates_uniqueness_of :user_id
  validates :frequency, presence: true, inclusion: { in: [0, 30, 180, 365]}

  before_save :save_with_markdown

  def picture?
    self.figure_id ? true : false
  end

  def picture_url
    if self.figure_id
      Figure.select( :id, :picture, :user_id ).find( self.figure_id ).picture_url
    else
      nil
    end
  end

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
    if self.biography.present?
      self.content_markdown = redcarpet.render(self.biography)
    end
  end
end
