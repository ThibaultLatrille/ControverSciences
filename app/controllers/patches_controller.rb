class PatchesController < ApplicationController
  before_action :logged_in_user, only: [:accept, :mine, :modal, :new, :target, :create, :destroy, :index]
  before_action :admin_user, only: [:index]

  def modal
    @patch = GoPatch.new(get_params)
    @patch.target_user_id = @patch.parent.user_id
    @patch.user_id = current_user.id
    respond_to do |format|
      format.js { render 'patches/modal', :content_type => 'text/javascript', :layout => false }
    end
  end

  def mine
    patches = GoPatch.where(user_id: current_user.id,
                            field: get_params[:field],
                            summary_id: get_params[:summary_id],
                            comment_id: get_params[:comment_id],
                            frame_id: get_params[:frame_id])
    dmp = DiffMatchPatch.new
    @patch = patches.first
    if @patch
      @text = @patch.parent_content
      @new_text = dmp.patch_apply(patches.map { |patch| dmp.patch_from_text(patch.content) }.flatten, @text)[0]
    end
  end

  def new
    @patch = GoPatch.new(get_params)
    @patch.target_user_id = @patch.parent.user_id
    @patch.user_id = current_user.id
    @patch.content = @patch.parent_content
    if params[:edit]
      dmp = DiffMatchPatch.new
      @patch.content = dmp.patch_apply(GoPatch.where(user_id: current_user.id,
                                                     field: get_params[:field],
                                                     summary_id: get_params[:summary_id],
                                                     comment_id: get_params[:comment_id],
                                                     frame_id: get_params[:frame_id])
                                           .map { |patch| dmp.patch_from_text(patch.content) }
                                           .flatten,
                                       @patch.content)[0].force_encoding("UTF-8")
    end
  end

  def create
    @patch = GoPatch.new(patch_params)
    @patch.target_user_id = @patch.parent.user_id
    @patch.user_id = current_user.id
    parent_content = @patch.parent_content
    if @patch.content_errors.full_messages.blank?
      @patch.save_as_list(parent_content)
      redirect_to patches_mine_path(frame_id: @patch.frame_id,
                                    summary_id: @patch.summary_id,
                                    comment_id: @patch.comment_id,
                                    field: @patch.field)
    else
      @patch.content_errors.full_messages.each do |message|
        @patch.errors.add(:base, message)
      end
      render 'new'
    end
  end

  def target
    @patches = GoPatch.where(summary_id: get_params[:summary_id],
                      comment_id: get_params[:comment_id],
                      frame_id: get_params[:frame_id])
    unless current_user.admin
      @patches = @patches.where(target_user_id: current_user.id)
    end
    if get_params[:summary_id]
      @patches = @patches.includes(:summary)
    end
    if get_params[:comment_id]
      @patches = @patches.includes(:summary)
    end
    if get_params[:frame_id]
      @patches = @patches.includes(:frame)
    end
  end

  def index
    @patches = GoPatch.includes(:frame).includes(:summary).includes(:comment).where.not(target_user_id: current_user.id )
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
      redirect_to patches_target_path(frame_id: @patch.frame_id,
                                      summary_id: @patch.summary_id,
                                      comment_id: @patch.comment_id)
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
      redirect_to patches_target_path(frame_id: @patch.frame_id,
                                      summary_id: @patch.summary_id,
                                      comment_id: @patch.comment_id)
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
