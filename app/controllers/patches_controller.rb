class PatchesController < ApplicationController
  before_action :logged_in_user, only: [:accept, :mine, :modal, :new, :target, :create, :index]

  def modal
    @patch = GoPatch.new(get_params)
    @patch.target_user_id = @patch.parent.user_id
    @patch.user_id = current_user.id
    if @patch.target_user_id == current_user.id
      @user_counter = GoPatch.where(target_user_id: current_user.id,
                               summary_id: @patch.summary_id,
                               comment_id: @patch.comment_id,
                               frame_id: @patch.frame_id).sum(:counter)
      else
      @counter = GoPatch.where(field: @patch.field,
                               summary_id: @patch.summary_id,
                               comment_id: @patch.comment_id,
                               frame_id: @patch.frame_id).sum(:counter)
    end
    respond_to do |format|
      format.js { render 'patches/modal', :content_type => 'text/javascript', :layout => false }
    end
  end

  def mine
    @patch = GoPatch.find_by(get_params)
  end

  def new
    @patch = GoPatch.find_or_initialize_by(get_params)
    if @patch.id
      message = PatchMessage.find_by(go_patch_id: @patch.id, user_id: current_user.id)
      if message
        @patch.message = message.message
      end
    end
    if @patch.summary_id || (@patch.comment_id && @patch.field != 6)
      @tim_list = timelines_connected_to(@patch.parent.timeline_id)
      @list = Reference.order(year: :desc).where(timeline_id: @patch.parent.timeline_id)
                  .pluck(:title, :id, :author, :year)
    elsif @patch.frame_id && @patch.field == 1
      @tim_list = timelines_connected_to(@patch.parent.timeline_id)
    end
  end

  def create
    @patch = GoPatch.find_or_initialize_by(get_params)
    @patch.counter = params[:counter]
    @patch.content = params[:content]
    @patch.message = params[:message]
    @patch.target_user_id = @patch.parent.user_id
    @patch.user_id = current_user.id
    @patch.content_errors(params[:length].to_i)
    if @patch.errors.full_messages.blank? && @patch.save
      @patch.save_message
      render 'patches/success'
    else
      render 'patches/fail'
    end
  end

  def target
    @patches = GoPatch.where(summary_id: get_params[:summary_id],
                             comment_id: get_params[:comment_id],
                             frame_id: get_params[:frame_id]).includes(:patch_messages)
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
    query = GoPatch.includes(:frame).includes(:summary).includes(:comment).includes(:patch_messages)
    if current_user.admin
      @patches = query.where.not(target_user_id: current_user.id)

    else
      @patches = query.where(target_user_id: current_user.id)
    end
  end

  def accept
    @patch = GoPatch.find_by(get_params)
    @patch.counter = params[:counter]
    @patch.content = params[:content]
    if @patch.target_user_id == current_user.id || current_user.admin
      if @patch.accept_and_save(params[:parent_content])
        User.increment_counter(:target_patches, @patch.target_user_id)
        render body: nil, :status => 201, :content_type => 'text/html'
      else
        render body: nil, :status => 409, :content_type => 'text/html'
      end
    else
      render body: nil, :status => 403, :content_type => 'text/html'
    end
  end

  private

  def get_params
    if params[:comment_id].present?
      params.permit(:comment_id, :field)
    elsif params[:summary_id].present?
      params.permit(:summary_id)
    elsif params[:frame_id].present?
      params.permit(:field, :frame_id)
    end
  end

  def patch_params
    params.require(:go_patch).permit(:comment_id, :summary_id, :frame_id, :content, :field)
  end
end
