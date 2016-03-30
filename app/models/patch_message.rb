class PatchMessage < ActiveRecord::Base
  belongs_to :go_patch
  belongs_to :comment
  belongs_to :summary
  belongs_to :frame
  belongs_to :user

  validates_uniqueness_of :user_id, :if => Proc.new { |c| not c.go_patch_id.blank? }, :scope => [:go_patch_id]

  def target_user_id
    if !summary_id.blank?
      self.summary.user_id
    elsif !comment_id.blank?
      self.comment.user_id
    elsif !frame_id.blank?
      self.frame.user_id
    end
  end
end
