class UserPatchesController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @user_patches = UserPatch.includes(go_patch: :summary)
                        .includes( go_patch: :frame)
                        .includes( go_patch: :comment)
                        .where(user_id: current_user.id)
  end

end
