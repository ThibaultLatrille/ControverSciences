class PatchMessagesController < ApplicationController
  before_action :logged_in_user, only: [:destroy]

  def destroy
    patch_message = PatchMessage.find(params[:id])
    if patch_message.target_user_id == current_user.id ||current_user.admin
      patch_message.destroy
    end
    respond_to do |format|
      format.js { render 'patch_messages/destroy', :content_type => 'text/javascript', :layout => false }
    end
  end
end
