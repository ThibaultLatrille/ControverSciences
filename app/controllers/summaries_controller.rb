class SummariesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def new
    if params[:parent_id]
      @parent = Summary.find(params[:parent_id])
      session[:timeline_id] = @parent.timeline_id
      @summary = @parent
    elsif params[:draft_id]
      @summary = SummaryDraft.find(params[:draft_id])

      session[:timeline_id] = @summary.timeline_id
      if @summary.parent_id
        @parent = Summary.find(@summary.parent_id)
      end
    else
      @summary = Summary.new
    end
    session[:timeline_id] = params[:timeline_id]
    @list = Reference.where( timeline_id: session[:timeline_id] ).pluck( :title, :id )
  end

  def create
    if params[:draft]
      if summary_params[:draft_id]
        @summary = SummaryDraft.find(summary_params[:draft_id])
      else
        @summary = SummaryDraft.new({user_id: current_user.id,
                                     timeline_id: summary_params[:timeline_id],
                                     parent_id: summary_params[:id]})
      end
      @summary.content = summary_params[:content]
      if @summary.user_id == current_user.id
        if @summary.save
          flash.now[:success] = "Brouillon sauvé"
        else
          flash.now[:danger] = "Erreur"
        end
      end
      @list = Reference.where( timeline_id: summary_params[:timeline_id] ).pluck( :title, :id )
      if summary_params[:parent_id]
        @parent = Summary.find(summary_params[:parent_id])
        params[:parent_id] = summary_params[:paren_id]
      end
      params[:draft_id] = @summary.id
      render 'new'
    else
      @summary = Summary.new({user_id: current_user.id,
                              timeline_id: summary_params[:timeline_id]})
      @summary.content = summary_params[:content]
      parent_id = summary_params[:parent_id]
      if @summary.save_with_markdown( timeline_url( summary_params[:timeline_id] ) )
        if parent_id
          SummaryRelationship.create(parent_id: parent_id, child_id: @summary.id)
        end
        if summary_params[:draft_id]
          summary = SummaryDraft.find(summary_params[:draft_id])
          if summary.user_id == current_user.id
            summary.destroy
          end
        end
        flash[:success] = "Edition enregistré"
        redirect_to summary_path(@summary.id)
      else
        @list = Reference.where( timeline_id: summary_params[:timeline_id] ).pluck( :title, :id )
        if summary_params[:parent_id]
          @parent = Summary.find(summary_params[:parent_id])
          params[:parent_id] = summary_params[:paren_id]
        end
        params[:draft_id] = summary_params[:draft_id]
        render 'new'
      end
    end
  end

  def show
    @summary = Summary.select( :id, :user_id, :timeline_id,
                               :markdown, :balance, :best,
                               :created_at
    ).find(params[:id])
    session[:timeline_id] = @summary.timeline_id
  end
  
  def index
    if logged_in?
      session[:timeline_id] = params[:timeline_id]
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
      flash[:danger] = "Ce résumé est le meilleur est ne peux être supprimer"
      redirect_to summary_path(params[:id])
    end
  end

  private

  def summary_params
    params.require(:summary).permit(:timeline_id, :content, :draft_id, :parent_id)
  end
end
