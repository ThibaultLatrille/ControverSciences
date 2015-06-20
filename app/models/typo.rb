class Typo < ActiveRecord::Base
  belongs_to :user
  belongs_to :summary
  belongs_to :comment
  belongs_to :frame

  belongs_to :target_user, class_name: "User", foreign_key: "target_user_id"

  def old_content
    if !summary_id.blank?
      self.summary.content
    elsif !comment_id.blank?
      self.comment.field_content( self.field.to_i )
    elsif !frame_id.blank?
      case self.field.to_i
        when 0
          self.frame.name
        when 1
          self.frame.content
      end
    end
  end

  def summary_short
    Summary.select(:id, :user_id, :timeline_id).find(self.summary_id)
  end

  def comment_short
    Comment.select(:id, :user_id, :reference_id, :timeline_id).find(self.comment_id)
  end

  def frame_short
    Frame.select(:id, :user_id, :timeline_id).find(self.frame_id)
  end

  def set_content(current_user_id)
    if !summary_id.blank?
      sum = self.summary
      if sum.user_id == current_user_id
        sum.content = self.content
        sum.update_with_markdown
      else
        false
      end
    elsif !comment_id.blank?
      com = self.comment
      if com.user_id == current_user_id
        case self.field
          when 6
            com.title = self.content
          when 7
            com.caption = self.content
          else
            com["f_#{field}_content"] = self.content
        end
        com.update_with_markdown
      else
        false
      end
    elsif !frame_id.blank?
      fra = self.frame
      if fra.user_id == current_user_id
        case self.field
          when 0
            fra.name = self.content
          when 1
            fra.content = self.content
        end
        fra.save_with_markdown
      else
        false
      end
    end
  end

end
