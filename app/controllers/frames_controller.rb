class FramesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :destroy_binaries]

  def new
    frame = Frame.find_by(user_id: current_user.id, timeline_id: params[:timeline_id])
    if frame
      redirect_to edit_frame_path(id: frame.id)
    else
      @frame = Frame.new
      frame = Frame.find_by(best: true, timeline_id: params[:timeline_id])
      @frame.name = frame.name
      @frame.content = frame.content
      @frame.timeline_id = params[:timeline_id]
      @frame.binary = frame.binary
      if @frame.binary != ''
        @frame.binary_left = @frame.binary.split('&&')[0]
        @frame.binary_right = @frame.binary.split('&&')[1]
        @frame.binary = true
      else
        @frame.binary = false
      end
    end
    @my_timeline = Timeline.select(:id, :slug, :nb_frames, :name).find(@frame.timeline_id)
  end

  def create
    @frame = Frame.new(timeline_id: frame_params[:timeline_id],
                       content: frame_params[:content],
                       why: frame_params[:why],
                       name: frame_params[:name])
    @frame.user_id = current_user.id
    if frame_params[:binary] != "0"
      @frame.binary = "#{frame_params[:binary_left].strip}&&#{frame_params[:binary_right].strip}"
    else
      @frame.binary = ''
    end
    if @frame.save
      flash[:success] = t('controllers.frame_saved')
      redirect_to frames_path(filter: "mine", timeline_id: @frame.timeline_id)
    else
      if @frame.binary != ''
        @frame.binary_left = @frame.binary.split('&&')[0]
        @frame.binary_right = @frame.binary.split('&&')[1]
        @frame.binary = true
      else
        @frame.binary = false
      end
      @my_timeline = Timeline.select(:id, :slug, :nb_frames, :name).find(@frame.timeline_id)
      render 'new'
    end
  end

  def edit
    @frame = Frame.find(params[:id])
    if GoPatch.where(frame_id: params[:id]).count > 0
      flash[:danger] = t('controllers.patches_pending')
      redirect_to patches_target_path(frame_id: params[:id])
    else
      @my_timeline = Timeline.select(:id, :slug, :nb_frames, :name).find(@frame.timeline_id)
      if @frame.binary != ''
        @frame.binary_left = @frame.binary.split('&&')[0]
        @frame.binary_right = @frame.binary.split('&&')[1]
        @frame.binary = true
      else
        @frame.binary = false
      end
    end
  end

  def update
    @frame = Frame.find(params[:id])
    @my_frame = Frame.find(params[:id])
    if @frame.user_id == current_user.id || current_user.admin
      if GoPatch.where(frame_id: params[:id]).count > 0
        flash[:danger] = t('controllers.patches_pending')
        redirect_to patches_target_path(frame_id: params[:id])
      else
        if frame_params[:binary] != "0"
          @frame.binary = "#{frame_params[:binary_left].strip}&&#{frame_params[:binary_right].strip}"
        else
          @frame.binary = ''
        end
        @frame.content = frame_params[:content]
        @frame.name = frame_params[:name]
        @frame.why = frame_params[:why]
        if @frame.save_with_markdown
          flash[:success] = t('controllers.frame_updated')
          redirect_to @frame
        else
          @my_timeline = Timeline.select(:id, :slug, :nb_frames, :name).find(@frame.timeline_id)
          render 'edit'
        end
      end
    else
      redirect_to @frame
    end
  end

  def show
    @frame = Frame.find(params[:id])
    if logged_in?
      @improve = Frame.where(user_id: current_user.id, timeline_id: @frame.timeline_id).count == 1 ? false : true
      @my_frame_credit = FrameCredit.find_by(user_id: current_user.id, timeline_id: @frame.timeline_id)
      @only_one_frame = Frame.where(timeline_id: @frame.timeline_id).count == 1
    end
    @timeline = Timeline.find(@frame.timeline_id)
  end

  def index
    @timeline = Timeline.find(params[:timeline_id])
    if logged_in?
      user_id = current_user.id
      @timeline.update_visite_by_user(user_id)
      @improve = Frame.where(user_id: user_id, timeline_id: params[:timeline_id]).count == 1 ? false : true
      @my_frame_credit = FrameCredit.find_by(user_id: user_id, timeline_id: params[:timeline_id])
      if params[:filter] == "mine"
        @frames = Frame.where(user_id: user_id, timeline_id: params[:timeline_id])
      elsif params[:filter] == "my-vote" && @my_frame_credit
        @frames = Frame.where(id: @my_frame_credit.frame_id).page(params[:page]).per(15)
      else
        @frames = Frame.where(timeline_id: params[:timeline_id])
      end
    else
      query = Frame.where(timeline_id: params[:timeline_id])
      if params[:sort].nil?
        if params[:order].nil?
          query = query.order(:score => :desc)
        else
          query = query.order(:score => params[:order].to_sym)
        end
      else
        if params[:order].nil?
          query = query.order(params[:sort].to_sym => :desc)
        else
          query = query.order(params[:sort].to_sym => params[:order].to_sym)
        end
      end
      @frames = query
    end
  end

  def destroy
    frame = Frame.find(params[:id])
    if frame.user_id == current_user.id || current_user.admin
      if frame.destroy_with_counters
        flash[:success] = t('controllers.frame_deleted')
        redirect_to timeline_path(frame.timeline_id)
      else
        flash[:danger] = t('controllers.frame_cannot_delete')
        redirect_to frame_path(params[:id])
      end
    else
      flash[:danger] = t('controllers.frame_cannot_delete')
      redirect_to frame_path(params[:id])
    end
  end

  def destroy_binaries
    frame = Frame.find(params[:frame_id])
    if current_user.id == frame.user_id || current_user.admin
      Reference.where(timeline_id: frame.timeline_id).update_all(binary_most: 0,
                                                       binary_1: 0, binary_2: 0,
                                                       binary_3: 0, binary_4: 0, binary_5: 0)

      Binary.where(frame_id: frame.id).destroy_all
    end
    respond_to do |format|
      format.js { render 'frames/success', :content_type => 'text/javascript', :layout => false}
    end
  end

  private

  def frame_params
    params.require(:frame).permit(:timeline_id, :content, :name, :binary, :why, :frame_timeline_id, :binary_left, :binary_right, :caption, :delete_picture, :has_picture)
  end
end
