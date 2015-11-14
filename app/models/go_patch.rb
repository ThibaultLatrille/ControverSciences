class GoPatch < ActiveRecord::Base
  belongs_to :user
  belongs_to :summary
  belongs_to :comment
  belongs_to :frame

  belongs_to :target_user, class_name: "User", foreign_key: "target_user_id"

  after_create :increment_nb_notifs
  after_destroy :decrement_nb_notifs

  def save_as_list
    dmp = DiffMatchPatch.new
    patches = dmp.patch_make(self.old_content, content)
    puts "bim"
    puts old_content
    puts content
    puts patches
    patches.each do |patch|
      puts dmp.patch_to_text(patch)
      new = GoPatch.new(content: dmp.patch_to_text(patch),
                      comment_id: comment_id, summary_id: summary_id,
                      target_user_id: target_user_id, field: field,
                      frame_id: frame_id, user_id: user_id)
      new.save!
    end
  end

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

  def new_content(text)
    dmp = DiffMatchPatch.new
    dmp.patch_apply(dmp.patch_from_text(self.content), text)[0]
  end

  def apply_content(current_user_id, admin)
    if !summary_id.blank?
      sum = self.summary
      if sum.user_id == current_user_id || admin
        sum.content = new_content(sum.content)
        sum.update_with_markdown
      else
        false
      end
    elsif !comment_id.blank?
      com = self.comment
      if com.user_id == current_user_id || admin
        case self.field
          when 6
            com.title = new_content(com.title)
          when 7
            com.caption = new_content(com.caption)
          else
            com["f_#{field}_content"] = new_content(com["f_#{field}_content"])
        end
        com.update_with_markdown
      else
        false
      end
    elsif !frame_id.blank?
      fra = self.frame
      if fra.user_id == current_user_id || admin
        if self.field == 0
          fra.name = new_content(fra.name)
        else
          fra.content = new_content(fra.content)
        end
        fra.save_with_markdown
      else
        false
      end
    end
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
    unless User.select(:private_timeline).find(self.target_user_id).private_timeline
      User.increment_counter(:nb_notifs, self.target_user_id)
    end
  end

  def decrement_nb_notifs
    unless User.select(:private_timeline).find(self.target_user_id).private_timeline
      User.decrement_counter(:nb_notifs, self.target_user_id)
    end
  end
end
