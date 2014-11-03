class ReferencesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def new
    session[:reference_params] ||= {user_id: current_user.id, timeline_id: session[:timeline_id]}
    @reference = Reference.new(session[:reference_params])
    @reference.current_step = session[:reference_step]
  end

  def create
    if params[:stop_button]
      session[:reference_step] = session[:reference_params] = nil
      return redirect_to root_path
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
    session[:timeline_name] = @reference.timeline.name
    @comment = Comment.new()
    @comments = Hash.new()
    @comments_user = Hash.new()
    for fi in 1..5
      @comments[fi] = @reference.comments.order(rank: :desc).where(field: fi).first(5)
      if logged_in?
      @comments_user[fi] = @reference.comments.where(field: fi, user: current_user.id).first
      end
    end
    sum = @reference.star_1+@reference.star_2+@reference.star_3+@reference.star_4+@reference.star_5
    if sum != 0
      @rating = {}
      @rating[1] = @reference.star_1*100/sum
      @rating[2] = @reference.star_2*100/sum
      @rating[3] = @reference.star_3*100/sum
      @rating[4] = @reference.star_4*100/sum
      @rating[5] = @reference.star_5*100/sum
    else
      @rating = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, panel: "default" }
    end
    case @reference.star_most
      when 1
        @rating[:panel] = "danger"
      when 2
        @rating[:panel] = "warning"
      when 3
        @rating[:panel] = "success"
      when 4
        @rating[:panel] = "info"
      when 5
        @rating[:panel] = "primary"
      else
        @rating[:panel] = "default"
    end
  end

  private

  def reference_params
    params.require(:reference).permit(:title, :title_fr, :author, :year, :doi, :journal, :abstract)
  end

end
