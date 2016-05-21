class UserPatch < ActiveRecord::Base
  belongs_to :user
  belongs_to :go_patch

  validates_uniqueness_of :user_id, :if => Proc.new { |c| not c.go_patch_id.blank? }, :scope => [:go_patch_id]
end
