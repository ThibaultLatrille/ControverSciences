class TimelinesController < ApplicationController
  before_action :logged_in_user, only: [:new, :edit, :update, :create, :destroy]

  def index
    query = Timeline.order(params[:sort].blank? ? :score : params[:sort].to_sym =>
                               params[:order].blank? ? :desc : params[:order].to_sym)
    if params[:tag] != 'all' && !params[:tag].blank?
      query = query.tagged_with(params[:tag])
    end
    unless params[:filter].blank?
      query = query.search_by_name(params[:filter])
    end
    @timelines = query.page(params[:page]).per(24)
    if logged_in?
      @my_likes = Like.where(user_id: current_user.id).pluck( :timeline_id )
    end
  end

  def new
    @timeline = Timeline.new
    @timeline.binary = true
    @tag_list = []
  end

  def edit
    @timeline = Timeline.find( params[:id] )
    @tag_list = @timeline.get_tag_list
    if @timeline.binary != ""
      @timeline.binary_left = @timeline.binary.split('&&')[0]
      @timeline.binary_right = @timeline.binary.split('&&')[1]
      @timeline.binary = true
    else
      @timeline.binary = false
    end
  end

  def update
    @timeline = Timeline.find( params[:id] )
    if @timeline.user_id == current_user.id
      @timeline.name = timeline_params[:name]
      if timeline_params[:binary] != "0"
        @timeline.binary = "#{timeline_params[:binary_left].strip}&&#{timeline_params[:binary_right].strip}"
      else
        @timeline.binary = ""
      end
      if params[:timeline][:tag_list]
        @timeline.set_tag_list(params[:timeline][:tag_list])
      end
      if @timeline.save
          flash[:success] = "Controverse modifiée."
          redirect_to @timeline
      else
        @tag_list = @timeline.get_tag_list
        @timeline.binary_left = @timeline.binary.split('&&')[0]
        @timeline.binary_right = @timeline.binary.split('&&')[1]
        @timeline.binary = true
        render 'edit'
      end
    else
      redirect_to @timeline
    end
  end

  def create
    @timeline = Timeline.new( user_id: current_user.id, name: timeline_params[:name], debate: true)
    if timeline_params[:binary] == "1"
      @timeline.binary = "#{timeline_params[:binary_left].strip}&&#{timeline_params[:binary_right].strip}"
    else
      @timeline.binary = ""
    end
    if params[:timeline][:tag_list]
      @timeline.set_tag_list(params[:timeline][:tag_list])
    end
    if @timeline.save
        flash[:success] = "Controverse ajoutée !"
        redirect_to @timeline
    else
      @tag_list = @timeline.get_tag_list
      if @timeline.binary != ""
        @timeline.binary_left = @timeline.binary.split('&&')[0]
        @timeline.binary_right = @timeline.binary.split('&&')[1]
        @timeline.binary = true
      else
        @timeline.binary = false
      end
      render 'new'
    end
  end

  def show
    @timeline = Timeline.find(params[:id])
    summary_best = SummaryBest.find_by(timeline_id: params[:id])
    if summary_best
      @summary = Summary.find( summary_best.summary_id )
    else
      @summary = nil
    end
    if logged_in?
      @my_likes = Like.where(user_id: current_user.id).pluck( :timeline_id )
      @improve = Summary.where(user_id: current_user.id, timeline_id: params[:id]).count == 1 ? false : true
    end
    @titles = Reference.where( timeline_id: @timeline.id, title_fr: [nil, ""] ).count
    @references = Reference.select( :article, :id, :title_fr, :title, :year, :binary_most, :star_most, :nb_edits).order( year: :desc).where( timeline_id: @timeline.id )
  end

  def destroy
    timeline = Timeline.find(params[:id])
    if timeline.user_id == current_user.id
      timeline.destroy
      redirect_to my_items_items_path
    end
  end

  private

  def timeline_params
    params.require(:timeline).permit(:name, :binary, :binary_left, :binary_right)
  end
end
