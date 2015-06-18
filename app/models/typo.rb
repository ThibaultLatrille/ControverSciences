class Typo < ActiveRecord::Base
  belongs_to :user
  belongs_to :summary
  belongs_to :comment
  belongs_to :frame

  belongs_to :target_user, class_name: "User", foreign_key: "target_user_id"

  def old_content
    if !summary_id.blank?
      self.summary.content
    elsif !comment.blank?
      self.comment.field_content( self.field.to_i )
    end
  end

  def summary_short
    Summary.select(:id, :user_id, :timeline_id).find(self.summary_id)
  end

  def comment_short
    Comment.select(:id, :user_id, :reference_id, :timeline_id).find(self.comment_id)
  end

  def set_content(current_user_id)
    render_options = {
        filter_html:     true,
        hard_wrap:       true,
        link_attributes: {rel: 'nofollow'},
        no_images:       true,
        no_styles:       true,
        safe_links_only: true
    }

    renderer       = HTMLlinks.new(render_options)
    renderer.links = []
    if Rails.env.production?
      renderer.ref_url = "http://www.controversciences.org/references/"
    else
      renderer.ref_url = "http://127.0.0.1:3000/references/"
    end

    extensions = {
        autolink:          true,
        lax_spacing:       true,
        no_intra_emphasis: true,
        strikethrough:     true,
        superscript:       true
    }
    redcarpet  = Redcarpet::Markdown.new(renderer, extensions)
    markdown = redcarpet.render(self.content)
    if !summary_id.blank?
      sum = self.summary
      if sum.user_id == current_user_id
        sum.content = self.content
        sum.markdown = markdown
        sum.save
      else
        false
      end
    elsif !comment_id.blank?
      com = self.comment
      if com.user_id == current_user_id
        case self.field
          when 6
            com.title = content
            com.title_markdown = markdown
          when 7
            com.caption = content
            com.caption_markdown = markdown
          else
            com["f_#{field}_content"] = content
            com["markdown_#{field}"] = markdown
        end
        com.save
      else
        false
      end
    end
  end

end
