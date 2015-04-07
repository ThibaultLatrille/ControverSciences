class TimelinesController < ApplicationController
  before_action :logged_in_user, only: [:new, :edit, :update, :create, :destroy]

  def index
    if params[:tag] != 'all' && !params[:tag].nil?
      if !params[:sort].nil?
        if !params[:order].nil?
          @timelines = Timeline.tagged_with(params[:tag]).order(params[:sort].to_sym => params[:order].to_sym).page(params[:page]).per(24)
        else
          @timelines = Timeline.tagged_with(params[:tag]).order(params[:sort].to_sym => :desc).page(params[:page]).per(24)
        end
      else
        if !params[:order].nil?
          @timelines = Timeline.tagged_with(params[:tag]).order(:score => params[:order].to_sym).page(params[:page]).per(24)
        else
          @timelines = Timeline.tagged_with(params[:tag]).order(:score => :desc).page(params[:page]).per(24)
        end
      end
    else
      if !params[:sort].nil?
        if !params[:order].nil?
          @timelines = Timeline.order(params[:sort].to_sym => params[:order].to_sym).page(params[:page]).per(24)
        else
          @timelines = Timeline.order(params[:sort].to_sym => :desc).page(params[:page]).per(24)
        end
      else
        if !params[:order].nil?
          @timelines = Timeline.order(:score => params[:order].to_sym).page(params[:page]).per(24)
        else
          @timelines = Timeline.order(:score => :desc).page(params[:page]).per(24)
        end
      end
    end
  end

  def new
    @timeline = Timeline.new
  end

  def edit
    @timeline = Timeline.find( params[:id] )
    @tag_list = @timeline.get_tag_list
    if @timeline.binary != ""
      @timeline.binary = true
    end
  end

  def update
    @timeline = Timeline.find( params[:id] )
    if @timeline.user_id == current_user.id
      @timeline.name = timeline_params[:name]
      @timeline.debate = timeline_params[:debate]
      if timeline_params[:binary] != "0"
        @timeline.binary = "Non&&Oui"
      else
        @timeline.binary = ""
      end
      if params[:timeline][:tag_list]
        @timeline.set_tag_list(params[:timeline][:tag_list])
      end
      if @timeline.save
        if timeline_params[:debate] == '1'
          flash[:success] = "Controverse modifiée. Vous pouvez également modifier le fil de discussion portant sur le titre."
          sug = Suggestion.find_by_timeline_id( @timeline.id )
          redirect_to edit_suggestion_path ( sug.id )
        else
          flash[:success] = "Controverse modifiée."
          redirect_to @timeline
        end
      else
        render 'edit'
      end
    else
      redirect_to @timeline
    end
  end

  def create
    @timeline = Timeline.new( user_id: current_user.id, name: timeline_params[:name], debate: timeline_params[:debate])
    if timeline_params[:binary]
      @timeline.binary = "Non&&Oui"
    end
    if params[:timeline][:tag_list]
      @timeline.set_tag_list(params[:timeline][:tag_list])
    end
    if @timeline.save
      if timeline_params[:debate] == '1'
        flash[:success] = "Controverse crée ! Vous pouvez également modifier le fil de discussion portant sur le titre."
        sug = Suggestion.find_by_timeline_id( @timeline.id )
        redirect_to edit_suggestion_path ( sug.id )
      else
        flash[:success] = "Controverse ajoutée !"
        redirect_to @timeline
      end
    else
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
      @improve = Summary.where(user_id: current_user.id, timeline_id: params[:id]).count == 1 ? false : true
    end
    @references = Reference.select( :id, :title_fr, :title, :year, :binary_most, :nb_edits).order( year: :desc).where( timeline_id: @timeline.id )
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
    params.require(:timeline).permit(:name, :binary, :debate)
  end
end
