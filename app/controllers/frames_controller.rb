class FramesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    frame = Frame.find_by(user_id: current_user.id, timeline_id: params[:timeline_id])
    if frame
      redirect_to edit_frame_path(id: frame.id)
    else
      timeline           = Timeline.find(params[:timeline_id])
      @frame             = Frame.new
      frame              = Frame.find_by(best: true, timeline_id: params[:timeline_id])
      @frame.content     = frame.content
      @frame.name        = frame.name
      @frame.timeline_id = params[:timeline_id]
      @frame.binary      = timeline.binary
      if @frame.binary != ""
        @frame.binary_left  = @frame.binary.split('&&')[0]
        @frame.binary_right = @frame.binary.split('&&')[1]
        @frame.binary       = true
      else
        @frame.binary = false
      end
    end
    @my_timeline = Timeline.select(:id, :slug, :nb_frames, :name).find(@frame.timeline_id)
  end

  def create
    @frame         = Frame.new(timeline_id: frame_params[:timeline_id],
                               content:     frame_params[:content],
                               name:        frame_params[:name])
    @frame.user_id = current_user.id
    if @frame.save
      flash[:success] = "Contribution enregistrée."
      redirect_to frames_path(filter: "mine", timeline_id: @frame.timeline_id)
    else
      if @frame.binary != ""
        @frame.binary_left  = @frame.binary.split('&&')[0]
        @frame.binary_right = @frame.binary.split('&&')[1]
        @frame.binary       = true
      else
        @frame.binary = false
      end
      @my_timeline = Timeline.select(:id, :slug, :nb_frames, :name).find(@frame.timeline_id)
      render 'new'
    end
  end

  def edit
    @frame       = Frame.find(params[:id])
    @my_timeline = Timeline.select(:id, :slug, :nb_frames, :name).find(@frame.timeline_id)
    if @frame.binary != ""
      @frame.binary_left  = @frame.binary.split('&&')[0]
      @frame.binary_right = @frame.binary.split('&&')[1]
      @frame.binary       = true
    else
      @frame.binary = false
    end
  end

  def update
    @frame    = Frame.find(params[:id])
    @my_frame = Frame.find(params[:id])
    if @frame.user_id == current_user.id || current_user.admin
      if frame_params[:binary] != "0"
        @frame.binary = "#{frame_params[:binary_left].strip}&&#{frame_params[:binary_right].strip}"
      else
        @frame.binary = ""
      end
      @frame.content = frame_params[:content]
      @frame.name    = frame_params[:name]
      if @frame.save_with_markdown
        flash[:success] = "Contribution modifiée."
        redirect_to @frame
      else
        @my_timeline = Timeline.select(:id, :slug, :nb_frames, :name).find(@frame.timeline_id)
        render 'edit'
      end
    else
      redirect_to @frame
    end
  end

  def show
    @frame = Frame.find(params[:id])
    if logged_in?
      @improve         = Frame.where(user_id: current_user.id, timeline_id: @frame.timeline_id).count == 1 ? false : true
      @my_frame_credit = FrameCredit.find_by(user_id: current_user.id, timeline_id: params[:timeline_id])
    end
    @timeline = Timeline.select(:id, :slug, :user_id, :nb_frames, :name).find(@frame.timeline_id)
  end

  def index
    @timeline = Timeline.select(:id, :slug, :user_id, :nb_frames, :name).find(params[:timeline_id])
    if logged_in?
      user_id = current_user.id
      visit   = VisiteTimeline.find_by(user_id: user_id, timeline_id: params[:timeline_id])
      if visit
        visit.update(updated_at: Time.zone.now)
      else
        VisiteTimeline.create(user_id: user_id, timeline_id: params[:timeline_id])
      end
      @improve         = Frame.where(user_id: user_id, timeline_id: params[:timeline_id]).count == 1 ? false : true
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
        flash[:success] = "Contribution envoyée à la poubelle."
        redirect_to timeline_path(frame.timeline_id)
      else
        flash[:danger] = "Vous ne pouvez pas supprimer cette contribution."
        redirect_to frame_path(params[:id])
      end
    else
      flash[:danger] = "Vous ne pouvez pas supprimer cette contribution."
      redirect_to frame_path(params[:id])
    end
  end

  private

  def frame_params
    params.require(:frame).permit(:timeline_id, :content, :name, :binary, :frame_timeline_id, :binary_left, :binary_right, :caption, :delete_picture, :has_picture)
  end
end
