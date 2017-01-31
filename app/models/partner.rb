class Partner < ApplicationRecord
  require 'HTMLlinks'

  attr_accessor :delete_picture, :has_picture
  belongs_to :user
  has_many :partner_love, :dependent => :destroy

  validates :user_id, presence: true
  validates :name, presence: true, length: {maximum: 180}
  validates :url, presence: true, length: {maximum: 500}
  validates :description, presence: true, length: {maximum: 2500}
  validates :why, presence: true, length: {maximum: 2500}

  before_save :save_with_markdown

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
    renderer = RenderWithoutWrap.new( render_options )
    extensions = {
        autolink:           true,
        lax_spacing:        true,
        no_intra_emphasis:  true,
        strikethrough:      true,
        superscript:        true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    unless self.description.empty?
      self.description_markdown = redcarpet.render(self.description)
    end
    unless self.why.empty?
      self.why_markdown = redcarpet.render(self.why)
    end
    unless self.name.empty?
      self.name_markdown = redcarpet.render(self.name)
    end
  end
end
