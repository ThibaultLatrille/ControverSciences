class GoPatch < ActiveRecord::Base
  belongs_to :user
  belongs_to :frame
  belongs_to :target_user, class_name: "User", foreign_key: "target_user_id"

  after_create :increment_nb_notifs
  after_destroy :decrement_nb_notifs

  def save_as_list(old_content)
    GoPatch.where(field: field, frame_id: frame_id, user_id: user_id).destroy_all
    dmp = DiffMatchPatch.new
    patches = dmp.patch_make(old_content, self.content)
    patches.each do |patch|
      new = GoPatch.new(content: dmp.patch_to_text([patch]),
                        target_user_id: target_user_id, field: field,
                        frame_id: frame_id, user_id: user_id)
      new.save!
    end
  end

  def old_content
    case self.field.to_i
      when 0
        self.frame.name
      when 1
        self.frame.content
    end
  end

  def frame_short
    Frame.select(:id, :user_id, :timeline_id).find(self.frame_id)
  end

  def new_content(text)
    dmp = DiffMatchPatch.new
    dmp.patch_apply(dmp.patch_from_text(self.content), text)[0].force_encoding("UTF-8")
  end

  def apply_content(current_user_id, admin)
    fra = self.frame
    if fra.user_id == current_user_id || admin
      if self.field == 0
        original = fra.name
        modified = new_content(original)
        fra.name = modified
      else
        original = fra.content
        modified = new_content(original)
        fra.content = modified
      end
      dmp = DiffMatchPatch.new
      patch_total = dmp.patch_make(original, modified)
      if fra.save_with_markdown
        GoPatch.where(field: field, frame_id: frame_id).where.not(id: self.id).each do |go_patch|
          r = dmp.patch_from_text(go_patch.content)
          text = dmp.patch_apply(patch_total + r, original)[0].force_encoding("UTF-8")
          patch = dmp.patch_make(modified, text)
          go_patch.update_column(:content, dmp.patch_to_text(patch))
        end
      else
        false
      end
    else
      false
    end
  end

  def content_index
    self.frame_id*10 + self.field
  end

  def content_ch_max
    if self.field == 0
      180
    else
      2500
    end
  end

  def content_ch_min
    if self.field == 0
      0
    else
      180
    end
  end

  def content_errors
    fra = self.frame
    if self.field == 0
      fra.name = self.content
    else
      fra.content = self.content
    end
    fra.valid?
    fra.errors
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
