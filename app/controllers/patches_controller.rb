class PatchesController < ApplicationController
  before_action :logged_in_user, only: [:accept, :mine, :modal, :new, :create, :destroy, :index]
  before_action :admin_user, only: [:index]

  def modal
    @patch = GoPatch.new(get_params)
    @patch.target_user_id = @patch.frame.user_id
    @patch.user_id = current_user.id
    respond_to do |format|
      format.js { render 'patches/modal', :content_type => 'text/javascript', :layout => false }
    end
  end

  def mine
    patches = GoPatch.where(user_id: current_user.id,
                            field: get_params[:field],
                            frame_id: get_params[:frame_id])
    dmp = DiffMatchPatch.new
    @patch = patches.first
    if @patch
      @text = @patch.old_content
      @new_text = dmp.patch_apply(patches.map { |patch| dmp.patch_from_text(patch.content) }.flatten, @text)[0]
    end
  end

  def new
    @patch = GoPatch.new(get_params)
    @patch.target_user_id = @patch.frame.user_id
    @patch.user_id = current_user.id
    if @patch.field.to_i == 0
      @patch.content = @patch.frame.name
    else
      @patch.content = @patch.frame.content
    end
    if params[:edit]
      dmp = DiffMatchPatch.new
      @patch.content = dmp.patch_apply(GoPatch.where(user_id: current_user.id,
                                                     field: get_params[:field],
                                                     frame_id: get_params[:frame_id])
                                           .map { |patch| dmp.patch_from_text(patch.content) }
                                           .flatten,
                                       @patch.content)[0].force_encoding("UTF-8")
    end
    @patch.target_user_id = @patch.frame.user_id
    @patch.user_id = current_user.id
  end

  def create
    @patch = GoPatch.new(patch_params)
    @patch.target_user_id = @patch.frame.user_id
    @patch.user_id = current_user.id
    old_content = @patch.old_content
    if @patch.content_errors.full_messages.blank?
      @patch.save_as_list(old_content)
      redirect_to patches_mine_path(frame_id: @patch.frame_id, field: @patch.field )
    else
      @patch.content_errors.full_messages.each do |message|
        @patch.errors.add(:base, message)
      end
      render 'new'
    end
  end

  def index
    @patches = GoPatch.all
  end

  def accept
    @patch = GoPatch.find(params[:id])
    @patch.apply_content(current_user.id, current_user.admin)
    if @patch.target_user_id == current_user.id || current_user.admin
      @patch.destroy
      User.increment_counter(:my_patches, @patch.user_id)
      User.increment_counter(:target_patches, @patch.target_user_id)
    end
    if current_user.admin
      redirect_to patches_path
    else
      redirect_to notifications_important_path
    end
  end

  def destroy
    @patch = GoPatch.find(params[:id])
    if @patch.target_user_id == current_user.id || current_user.admin
      @patch.destroy
    end
    if current_user.admin
      redirect_to patches_path
    else
      redirect_to notifications_important_path
    end
  end

  private

  def get_params
    params.permit(:comment_id, :summary_id, :field, :frame_id)
  end

  def patch_params
    params.require(:go_patch).permit(:comment_id, :summary_id, :frame_id, :content, :field)
  end
end
