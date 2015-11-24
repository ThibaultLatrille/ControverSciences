class PatchesController < ApplicationController
  before_action :logged_in_user, only: [:accept, :create, :destroy, :index]
  before_action :admin_user, only: [:index]

  def new
    @patch = GoPatch.new( get_params )
    if !@patch.comment_id.blank?
      com = Comment.find(get_params[:comment_id])
      @patch.content = com.field_content(get_params[:field].to_i)
      @patch.target_user_id = com.user_id
    elsif !@patch.summary_id.blank?
      sum = Summary.select( :user_id, :content ).find(get_params[:summary_id])
      @patch.content = sum.content
      @patch.target_user_id = sum.user_id
    elsif !@patch.frame_id.blank?
      fra = Frame.find(get_params[:frame_id])
      if get_params[:field].to_i == 0
        @patch.content = fra.name
      else
        @patch.content = fra.content
      end
      @patch.target_user_id = fra.user_id
    end
    @patch.user_id = current_user.id
    respond_to do |format|
      format.js { render 'patches/new', :content_type => 'text/javascript', :layout => false}
    end
  end

  def create
    @patch = GoPatch.new( patch_params )
    if !@patch.comment_id.blank?
      @patch.target_user_id = Comment.select( :user_id ).find(patch_params[:comment_id]).user_id
    elsif !@patch.summary_id.blank?
      @patch.target_user_id = Summary.select( :user_id ).find(patch_params[:summary_id]).user_id
    elsif !@patch.frame_id.blank?
      @patch.target_user_id = Frame.select( :user_id ).find(patch_params[:frame_id]).user_id
    end
    @patch.user_id = current_user.id
    if (@patch.target_user_id == @patch.user_id && !current_user.private_timeline) || current_user.admin
      if @patch.set_content(current_user.id, current_user.admin)
        respond_to do |format|
          format.js { render 'patches/mine', :content_type => 'text/javascript', :layout => false}
        end
      else
        @patch_errors = @patch.get_model_errors
        respond_to do |format|
          format.js { render 'patches/errors', :content_type => 'text/javascript', :layout => false}
        end
      end
    else
      old_content = @patch.old_content
      @patch_errors = @patch.is_content_valid
      if @patch_errors.full_messages.blank?
        if @patch.save_as_list(old_content)
          respond_to do |format|
            format.js { render 'patches/success', :content_type => 'text/javascript', :layout => false}
          end
        else
          respond_to do |format|
            format.js { render 'patches/fail', :content_type => 'text/javascript', :layout => false}
          end
        end
      else
        respond_to do |format|
          format.js { render 'patches/errors', :content_type => 'text/javascript', :layout => false}
        end
      end
    end
  end

  def index
    @patches = GoPatch.all
  end

  def accept
    @patch = GoPatch.find( params[:id] )
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
    @patch = GoPatch.find( params[:id] )
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
