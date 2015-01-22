class SummariesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    summary = Summary.find_by( user_id: current_user.id, timeline_id: params[:timeline_id] )
    if summary
      redirect_to edit_summary_path( id: summary.id, parent_id: params[:parent_id] )
    else
      @summary = Summary.new
      if params[:parent_id]
        @parent = Summary.find(params[:parent_id])
        @summary = @parent
      else
        @summary.timeline_id = params[:timeline_id]
      end
      @list = Reference.where( timeline_id: @summary.timeline_id ).pluck( :title, :id )
    end
  end

  def create
    @summary = Summary.new( summary_params )
    @summary.user_id = current_user.id
    parent_id = params[:summary][:parent_id]
    if @summary.save_with_markdown( timeline_url( summary_params[:timeline_id] ) )
      if parent_id
        SummaryRelationship.create(parent_id: parent_id, child_id: @summary.id)
      end
      flash[:success] = "Synthèse enregistrée"
      redirect_to summary_path( @summary.id )
    else
      @list = Reference.where( timeline_id: summary_params[:timeline_id] ).pluck( :title, :id )
      if parent_id
        @parent = Summary.find( parent_id )
      end
      render 'new'
    end
  end

  def edit
    @my_summary = Summary.find( params[:id] )
    @summary = @my_summary
    @list = Reference.where( timeline_id: @summary.timeline_id ).pluck( :title, :id )
    if params[:parent_id]
      @parent = Summary.find(params[:parent_id])
      if @parent.user_id != current_user.id
        @summary[:content] += "\n" + @parent[:content]
      else
        @parent = nil
      end
    end
  end

  def update
    @summary = Summary.find( params[:id] )
    @my_summary = Summary.find( params[:id] )
    if @summary.user_id == current_user.id
      @summary[:content] = summary_params[:content]
      if @summary.update_with_markdown( timeline_url( @summary.timeline_id ) )
        flash[:success] = "Synthèse modifiée"
        redirect_to @summary
      else
        @list = Reference.where( timeline_id: @summary.timeline_id ).pluck( :title, :id )
        if params[:summary][:parent_id]
          @parent = Summary.find(params[:summary][:parent_id])
        end
        render 'edit'
      end
    else
      redirect_to @summary
    end
  end

  def show
    @summary = Summary.select( :id, :user_id, :timeline_id,
                               :markdown, :balance, :best,
                               :created_at
    ).find(params[:id])
  end
  
  def index
    if logged_in?
      user_id = current_user.id
      @my_credits = Credit.where( user_id: user_id, timeline_id: params[:timeline_id] ).sum( :value )
      visit = VisiteTimeline.find_by( user_id: user_id, timeline_id: params[:timeline_id] )
      if visit
        visit.update( updated_at: Time.zone.now )
      else
        VisiteTimeline.create( user_id: user_id, timeline_id: params[:timeline_id] )
      end
    else
      user_id = nil
    end
    if params[:filter] == "my-vote"
      summary_ids = Credit.where( user_id: user_id, timeline_id: params[:timeline_id] ).pluck( :summary_id )
      @summaries = Summary.where( id: summary_ids ).page(params[:page]).per(10)
    elsif params[:filter] == "mine"
      @summaries = Summary.where( user_id: user_id, timeline_id: params[:timeline_id] ).page(params[:page]).per(10)
    elsif logged_in?
      if params[:seed]
        @seed = params[:seed]
      else
        @seed = rand
      end
      Summary.connection.execute("select setseed(#{@seed})")
      @summaries = Summary.where(
          timeline_id: params[:timeline_id] ).where.not(
          user_id: user_id).order('random()').page(params[:page]).per(5)
    else
      if !params[:sort].nil?
        if !params[:order].nil?
          @summaries = Summary.order(params[:sort].to_sym => params[:order].to_sym).where(
              timeline_id: params[:timeline_id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        else
          @summaries = Summary.order(params[:sort].to_sym => :desc).where(
              timeline_id: params[:timeline_id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        end
      else
        if !params[:order].nil?
          @summaries = Summary.order(:score => params[:order].to_sym).where(
              timeline_id: params[:timeline_id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        else
          @summaries = Summary.order(:score => :desc).page(params[:page]).where(
              timeline_id: params[:timeline_id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        end
      end
    end
  end

  def destroy
    summary = Summary.find(params[:id])
    if summary.user_id == current_user.id && !summary.best
      summary.destroy_with_counters
      redirect_to my_items_summaries_path
    else
      flash[:danger] = "Cette synthèse est la meilleure et ne peut être supprimée."
      redirect_to summary_path(params[:id])
    end
  end

  private

  def summary_params
    params.require(:summary).permit(:timeline_id, :content)
  end
end
