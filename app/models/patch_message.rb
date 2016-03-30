class PatchMessage < ActiveRecord::Base
  belongs_to :go_patch
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => [:go_patch_id]
end
