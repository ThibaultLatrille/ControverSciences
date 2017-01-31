class UserPatch < ApplicationRecord
  belongs_to :user
  belongs_to :go_patch

  validates_uniqueness_of :user_id, :if => Proc.new { |c| not c.go_patch_id.blank? }, :scope => [:go_patch_id]

  before_destroy :create_contributor

  private

  def create_contributor
    if self.go_patch.comment_id
      ContributorComment.create(user_id: self.user_id, comment_id: self.go_patch.comment_id)
    elsif self.go_patch.frame_id
      ContributorFrame.create(user_id: self.user_id, frame_id: self.go_patch.frame_id)
    elsif self.go_patch.summary_id
      ContributorSummary.create(user_id: self.user_id, summary_id: self.go_patch.summary_id)
    end
  end
end
