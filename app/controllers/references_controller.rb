class ReferencesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def new
    if params[:timeline_id]
      session[:timeline_id] = params[:timeline_id]
      session[:timeline_name] = Timeline.select( :name ).find( params[:timeline_id] ).name
    end
    session[:reference_params] ||= {user_id: current_user.id, timeline_id: session[:timeline_id]}
    @reference = Reference.new(session[:reference_params])
    @reference.current_step = session[:reference_step]
  end

  def create
    if params[:stop_button]
      session[:reference_step] = session[:reference_params] = nil
      redirect_to root_path
      return
    elsif params[:panel_button]
      session[:reference_params] = {user_id: current_user.id, timeline_id: session[:timeline_id]}
      @reference = Reference.new(session[:reference_params])
      @reference.current_step = session[:reference_step] = @reference.steps.first
      query = params[:reference][:title]
    else
      session[:reference_params].deep_merge!(params[:reference]) if params[:reference]
      @reference = Reference.new(session[:reference_params])
      @reference.current_step = session[:reference_step]
      query = @reference.title
    end
    if params[:back_button]
      @reference.previous_step
    elsif @reference.valid?
      if @reference.first_step?
        unless query.empty?
          begin
          @reference = fetch_reference( query )
          rescue ArgumentError
            flash.now[:danger] = "Votre requête avec n'a rien donné de concluant, vous allez devoir tout rentrer à la main :-("
          rescue ConnectionError
            flash.now[:danger] = "Impossible de se connecter aux serveurs qui délivrent les metadonnées"
          rescue StandardError
            flash.now[:danger] = "Une erreur que nous ne savons pas gérer est survenue inopinément !"
          end
        end
        @reference.next_step
      elsif @reference.last_step?
        #if not one reference with the same DOI
        @reference.save if @reference.all_valid?
      else
        @reference.next_step
      end
    end
    session[:reference_step] = @reference.current_step
    if @reference.new_record?
      render 'new'
    else
      session[:reference_step] = session[:reference_params] = nil
      flash[:success] = "Référence crée"
      redirect_to @reference
    end
  end

  def show
    @reference = Reference.find(params[:id])
    session[:reference_id] = params[:id]
    session[:reference_title] = @reference.title
    session[:timeline_id] = @reference.timeline_id
    session[:timeline_name] = @reference.timeline_name
    if logged_in?
      user_id = current_user.id
      @my_votes = Vote.where( user_id: user_id, reference_id: @reference.id).sum( :value )
      session[:my_votes] = @my_votes
    else
      user_id = nil
    end
    if params[:filter]
      comment_ids = Vote.where( user_id: user_id, reference_id: @reference.id).pluck( :comment_id )
      @comments = Comment.where( id: comment_ids ).page(params[:page]).per(10)
    else
      if !params[:sort].nil?
        if !params[:order].nil?
          @comments = Comment.order(params[:sort].to_sym => params[:order].to_sym).where(
              reference_id: params[:id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        else
          @comments = Comment.order(params[:sort].to_sym => :desc).where(
              reference_id: params[:id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        end
      else
        if !params[:order].nil?
          @comments = Comment.order(:created_at => params[:order].to_sym).where(
              reference_id: params[:id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        else
          @comments = Comment.order(:created_at => :desc).page(params[:page]).where(
              reference_id: params[:id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        end
      end
    end
    if logged_in?
      @user_rating = @reference.ratings.find_by(user_id: current_user.id)
      unless @user_rating.nil?
        @user_rating = @user_rating.value
      end
    end
  end

  def destroy
    reference = Reference.find(params[:id])
    if reference.user_id == current_user.id
      reference.destroy_with_counters
      redirect_to my_items_references_path
    end
  end

  private

  def reference_params
    params.require(:reference).permit(:title, :title_fr, :author, :year, :doi, :journal, :abstract)
  end

end
