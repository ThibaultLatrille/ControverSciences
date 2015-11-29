class GoPatch < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :user
  belongs_to :frame
  belongs_to :summary
  belongs_to :comment
  belongs_to :target_user, class_name: "User", foreign_key: "target_user_id"

  def parent_content_accessor
    if !summary_id.blank?
      "content"
    elsif !comment_id.blank?
      case self.field.to_i
        when 6
          "title"
        when 7
          "caption"
        else
          "f_#{field}_content"
      end
    elsif !frame_id.blank?
      if self.field.to_i == 0
        "name"
      else
        "content"
      end
    end
  end

  def parent
    if !summary_id.blank?
      self.summary
    elsif !comment_id.blank?
      self.comment
    elsif !frame_id.blank?
      self.frame
    end
  end

  def parent_content
    self.parent[self.parent_content_accessor]
  end

  def all_contributions
    if !summary_id.blank?
      self.summary.timeline.nb_summaries
    elsif !comment_id.blank?
      CommentJoin.where( reference_id: self.comment.reference_id, field: self.field ).count
    elsif !frame_id.blank?
      self.frame.timeline.nb_frames
    end
  end

  def mine_parent
    if !summary_id.blank?
      Summary.find_by(user_id: self.user_id, timeline_id: self.summary.timeline_id)
    elsif !comment_id.blank?
      Comment.find_by(user_id: self.user_id, reference_id: self.comment.reference_id)
    elsif !frame_id.blank?
      Frame.find_by(user_id: self.user_id, timeline_id: self.frame.timeline_id)
    end
  end

  def save_as_list(parent_content)
    GoPatch.where(field: field,
                  frame_id: frame_id,
                  summary_id: summary_id,
                  comment_id: comment_id,
                  user_id: user_id).destroy_all
    dmp = DiffMatchPatch.new
    patches = dmp.patch_make(parent_content, self.content)
    patches.each do |patch|
      new = GoPatch.new(content: dmp.patch_to_text([patch]),
                        target_user_id: target_user_id,
                        field: field,
                        frame_id: frame_id,
                        summary_id: summary_id,
                        comment_id: comment_id,
                        user_id: user_id)
      new.save!
    end
  end

  def frame_short
    Frame.select(:id, :user_id, :timeline_id).find(self.frame_id)
  end

  def summary_short
    Summary.select(:id, :user_id, :timeline_id).find(self.summary_id)
  end

  def comment_short
    Comment.select(:id, :user_id, :reference_id, :timeline_id).find(self.comment_id)
  end

  def new_content(text)
    dmp = DiffMatchPatch.new
    dmp.patch_apply(dmp.patch_from_text(self.content), text)[0].force_encoding("UTF-8")
  end

  def apply_content(current_user_id, admin)
    parent_model = self.parent
    if parent_model.user_id == current_user_id || admin
      original = parent_model[self.parent_content_accessor]
      modified = new_content(original)
      parent_model[self.parent_content_accessor] = modified
      dmp = DiffMatchPatch.new
      patch_total = dmp.patch_make(original, modified)
      if parent_model.save_with_markdown
        GoPatch.where(field: field,
                      frame_id: frame_id,
                      summary_id: summary_id,
                      comment_id: comment_id).where.not(id: self.id).each do |go_patch|
          r = dmp.patch_from_text(go_patch.content)
          text = dmp.patch_apply(patch_total + r, original)[0].force_encoding("UTF-8")
          patch = dmp.patch_make(modified, text)
          if patch.blank?
            go_patch.destroy
          else
            go_patch.update_column(:content, dmp.patch_to_text(patch))
          end
        end
      else
        false
      end
    else
      false
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

  def content_ch_max
    if !summary_id.blank?
      12500
    elsif !comment_id.blank?
      category_limit[self.comment.category][self.field]
    elsif !frame_id.blank?
      if self.field == 0
        180
      else
        2500
      end
    end
  end

  def content_ch_min
    if !summary_id.blank?
      0
    elsif !comment_id.blank?
      0
    elsif !frame_id.blank?
      if self.field == 0
        0
      else
        180
      end
    end
  end

  def content_errors
    parent_model = self.parent
    parent_model[self.parent_content_accessor] = self.content
    parent_model.valid?
    parent_model.errors
  end
end
