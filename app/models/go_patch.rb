class GoPatch < ActiveRecord::Base
  include ApplicationHelper

  belongs_to :user
  belongs_to :frame
  belongs_to :summary
  belongs_to :comment
  belongs_to :target_user, class_name: "User", foreign_key: "target_user_id"

  validates_numericality_of :counter, :only_integer => true,
                            :greater_than_or_equal_to => 1

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
      CommentJoin.where(reference_id: self.comment.reference_id, field: self.field).count
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

  def frame_short
    Frame.select(:id, :user_id, :timeline_id).find(self.frame_id)
  end

  def summary_short
    Summary.select(:id, :user_id, :timeline_id).find(self.summary_id)
  end

  def comment_short
    Comment.select(:id, :user_id, :reference_id, :timeline_id).find(self.comment_id)
  end

  def accept_and_save(parent_content)
    parent_model = self.parent
    parent_model[self.parent_content_accessor] = parent_content
    if parent_model.save_with_markdown
      query = GoPatch.where(frame_id: self.frame_id,
                            comment_id: self.comment_id,
                            field: self.field,
                            summary_id: self.summary_id)
      if self.counter > 0
        self.save
        query = query.where.not(id: self.id)
      end
      query.destroy_all
      true
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

  def content_errors(length)
    if length > content_ch_max
      errors.add(:base, I18n.t('errors.messages.too_long', count: content_ch_max))
    end
    if length < content_ch_min
      errors.add(:base, I18n.t('errors.messages.too_short', count: content_ch_max))
    end
    if self.counter == 0 || self.counter.blank?
      errors.add(:base, "Aucune suggestion n'a été apportée.")
    end
  end
end
