class PatchMessage < ApplicationRecord
  belongs_to :go_patch
  belongs_to :comment
  belongs_to :summary
  belongs_to :frame
  belongs_to :user

  validates_uniqueness_of :user_id, :if => Proc.new { |c| not c.go_patch_id.blank? }, :scope => [:go_patch_id]

  before_save :to_markdown

  def target_user_id
    if !summary_id.blank?
      self.summary.user_id
    elsif !comment_id.blank?
      self.comment.user_id
    elsif !frame_id.blank?
      self.frame.user_id
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
    renderer = Redcarpet::Render::HTML.new(render_options)
    extensions = {
        autolink: true,
        lax_spacing: true,
        no_intra_emphasis: true,
        strikethrough: true,
        superscript: true
    }
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)
    self.message_markdown = redcarpet.render(self.message)
  end
end
