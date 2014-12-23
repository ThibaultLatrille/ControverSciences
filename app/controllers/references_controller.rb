class ReferencesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def new
    session[:reference_id] = nil
    if params[:timeline_id]
      session[:timeline_id] = params[:timeline_id]
    end
    @reference = Reference.new
  end

  def create
    session[:reference_id] = nil
    @reference = Reference.new( reference_params )
    session[:timeline_id] = @reference.timeline_id
    @reference.user_id = current_user.id
    if params[:title] || params[:doi]
      if params[:title]
        query = params[:reference][:title]
      else
        query = params[:reference][:doi]
      end
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
      render 'new'
    else
      if @reference.save
        flash[:success] = "Référence créé"
        redirect_to @reference
      else
        render 'new'
      end
    end
  end

  def edit
    session[:reference_id] = params[:id]
    @reference = Reference.find( params[:id] )
    session[:timeline_id] = @reference.timeline_id
  end

  def update
    session[:reference_id] = params[:id]
    @reference = Reference.find( params[:id] )
    session[:timeline_id] = @reference.timeline_id
    if @reference.user_id == current_user.id
      if @reference.update( reference_params )
        flash[:success] = "Référence modifié"
        redirect_to @reference
      else
        render 'edit'
      end
    else
      redirect_to @reference
    end
  end

  def show
    @reference = Reference.find(params[:id])
    if logged_in?
      session[:reference_id] = params[:id]
      session[:timeline_id] = @reference.timeline_id
      user_id = current_user.id
      @my_votes = Vote.where( user_id: user_id, reference_id: @reference.id).sum( :value )
      @user_rating = @reference.ratings.find_by(user_id: user_id)
      unless @user_rating.nil?
        @user_rating = @user_rating.value
      end
      visit = VisiteReference.find_by( user_id: user_id, reference_id: params[:id] )
      if visit
        visit.update( updated_at: Time.zone.now )
      else
        VisiteReference.create( user_id: user_id, reference_id: params[:id] )
      end
    else
      user_id = nil
    end
    if params[:filter] == "my-vote"
      comment_ids = Vote.where( user_id: user_id, reference_id: @reference.id).pluck( :comment_id )
      @comments = Comment.where( id: comment_ids ).page(params[:page]).per(10)
    elsif params[:filter] == "mine"
      @comments = Comment.where( user_id: user_id, reference_id: @reference.id ).page(params[:page]).per(10)
    elsif logged_in?
      if params[:seed]
        @seed = params[:seed]
      else
        @seed = rand
      end
      Comment.connection.execute("select setseed(#{@seed})")
      @comments = Comment.where(
          reference_id: params[:id]).where.not(
          user_id: user_id).order('random()').page(params[:page]).per(5)
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
          @comments = Comment.order(:score => params[:order].to_sym).where(
              reference_id: params[:id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        else
          @comments = Comment.order(:score => :desc).page(params[:page]).where(
              reference_id: params[:id]).where.not(
              user_id: user_id).page(params[:page]).per(5)
        end
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
    params.require(:reference).permit(:title, :title_fr, :timeline_id,
                                      :open_access, :url, :author, :year, :doi, :journal, :abstract)
  end

end
