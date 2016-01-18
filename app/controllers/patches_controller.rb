class PatchesController < ApplicationController
  before_action :logged_in_user, only: [:accept, :mine, :modal, :new, :target, :create, :index]

  def modal
    @patch = GoPatch.new(get_params)
    @patch.target_user_id = @patch.parent.user_id
    @patch.user_id = current_user.id
    respond_to do |format|
      format.js { render 'patches/modal', :content_type => 'text/javascript', :layout => false }
    end
  end

  def mine
    @patch = GoPatch.find_by(field: get_params[:field],
                             summary_id: get_params[:summary_id],
                             comment_id: get_params[:comment_id],
                             frame_id: get_params[:frame_id])
  end

  def new
    @patch = GoPatch.new(get_params)
    @patch.target_user_id = @patch.parent.user_id
    @patch.user_id = current_user.id
    go_patch = GoPatch.find_by(field: get_params[:field],
                               summary_id: get_params[:summary_id],
                               comment_id: get_params[:comment_id],
                               frame_id: get_params[:frame_id])
    if go_patch
      @patch.content = go_patch.content
    end
  end

  def create
    @patch = GoPatch.new(frame_id: params[:frame_id],
                         field: params[:field],
                         comment_id: params[:comment_id],
                         summary_id: params[:summary_id],
                         counter: params[:counter],
                         content: params[:content])
    @patch.target_user_id = @patch.parent.user_id
    @patch.user_id = current_user.id
    @patch.content_errors(params[:length].to_i)
    if @patch.errors.full_messages.blank? && @patch.save
      GoPatch.where(frame_id: @patch.frame_id,
                    comment_id: @patch.comment_id,
                    field: @patch.field,
                    summary_id: @patch.summary_id).where.not(id: @patch.id).destroy_all
      render 'patches/success'
    else
      render 'patches/fail'
    end
  end

  def target
    @patches = GoPatch.where(summary_id: get_params[:summary_id],
                             comment_id: get_params[:comment_id],
                             frame_id: get_params[:frame_id])
    if current_user.admin
      @patches = @patches.where.not(target_user_id: current_user.id)
    else
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
    if current_user.admin
      @patches = GoPatch.includes(:frame).includes(:summary).includes(:comment).where.not(target_user_id: current_user.id)

    else
      @patches = GoPatch.includes(:frame).includes(:summary).includes(:comment).where(target_user_id: current_user.id)

    end
  end

  def accept
    @patch = GoPatch.new(frame_id: params[:frame_id],
                         field: params[:field],
                         counter: params[:counter],
                         comment_id: params[:comment_id],
                         summary_id: params[:summary_id],
                         content: params[:content])
    @patch.target_user_id = @patch.parent.user_id
    @patch.user_id = current_user.id
    if @patch.target_user_id == current_user.id || current_user.admin
      if @patch.accept_and_save(params[:parent_content])
        User.increment_counter(:target_patches, @patch.target_user_id)
        render :nothing => true, :status => 201
      else
        render :nothing => true, :status => 409
      end
    else
      render :nothing => true, :status => 403
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
