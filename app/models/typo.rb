class Typo < ActiveRecord::Base
  belongs_to :user
  belongs_to :summary
  belongs_to :comment
  belongs_to :frame

  belongs_to :target_user, class_name: "User", foreign_key: "target_user_id"

  after_create :increment_nb_notifs
  after_destroy :decrement_nb_notifs

  validates_uniqueness_of :user_id, :if => Proc.new { |c| not c.summary_id.blank? }, :scope => [:summary_id]
  validates_uniqueness_of :user_id, :if => Proc.new { |c| not c.comment_id.blank? }, :scope => [:comment_id, :field]
  validates_uniqueness_of :user_id, :if => Proc.new { |c| not c.frame_id.blank? }, :scope => [:frame_id, :field]

  def old_content
    if !summary_id.blank?
      self.summary.content
    elsif !comment_id.blank?
      self.comment.field_content(self.field.to_i)
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

  def set_content(current_user_id, admin)
    if !summary_id.blank?
      sum = self.summary
      if sum.user_id == current_user_id || admin
        sum.content = self.content
        sum.update_with_markdown
      else
        false
      end
    elsif !comment_id.blank?
      com = self.comment
      if com.user_id == current_user_id || admin
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
      if fra.user_id == current_user_id || admin
        if self.field == 0
          fra.name = self.content
        else
          fra.content = self.content
        end
        fra.save_with_markdown
      else
        false
      end
    end
  end

  def content_index
    if !summary_id.blank?
      self.summary_id
    elsif !comment_id.blank?
      self.comment_id*10 + self.field
    elsif !frame_id.blank?
      self.frame_id*10 + self.field
    end
  end

  def get_model_errors
    if !summary_id.blank?
      self.summary.errors
    elsif !comment_id.blank?
      self.comment.errors
    elsif !frame_id.blank?
      self.frame.errors
    end
  end

  def is_content_valid
    if !summary_id.blank?
      sum = self.summary
      sum.content = self.content
      sum.valid?
      sum.errors
    elsif !comment_id.blank?
      com = self.comment
      case self.field
        when 6
          com.title = self.content
        when 7
          com.caption = self.content
        else
          com["f_#{field}_content"] = self.content
      end
      com.valid?
      com.errors
    elsif !frame_id.blank?
      fra = self.frame
      if self.field == 0
        fra.name = self.content
      else
        fra.content = self.content
      end
      fra.valid?
      fra.errors
    end
  end

  private

  def increment_nb_notifs
    User.increment_counter(:nb_notifs, self.target_user_id)
  end

  def decrement_nb_notifs
    User.decrement_counter(:nb_notifs, self.target_user_id)
  end

end
