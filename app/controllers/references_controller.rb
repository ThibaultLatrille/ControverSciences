class ReferencesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def new
    if params[:timeline_id]
      session[:timeline_id] = params[:timeline_id]
    end
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
    best_comment = BestComment.find_by( reference_id: @reference.id )
    if best_comment
      @comment = Comment.find( @reference.id)
      @comments = Comment.order(balance: :desc ).where(
                   reference_id: @reference.id ).where.not(
                   id: best_comment.comment_id, user_id: current_user.id ).first(5)
    else
        @comment = nil
        @comments = []
    end
    if logged_in?
        @comments_user = @reference.comments.where(user_id: current_user.id)
    else
        @comments_user = []
    end
    sum = @reference.star_1+@reference.star_2+@reference.star_3+@reference.star_4+@reference.star_5
    if sum != 0
      @rating_hash = {}
      @rating_hash[1] = @reference.star_1*100/sum
      @rating_hash[2] = @reference.star_2*100/sum
      @rating_hash[3] = @reference.star_3*100/sum
      @rating_hash[4] = @reference.star_4*100/sum
      @rating_hash[5] = @reference.star_5*100/sum
    else
      @rating_hash = { 1 => 0, 2 => 0, 3 => 0, 4 => 0, 5 => 0, panel: "default" }
    end
    case @reference.star_most
      when 1
        @rating_hash[:panel] = "danger"
      when 2
        @rating_hash[:panel] = "warning"
      when 4
        @rating_hash[:panel] = "info"
      when 5
        @rating_hash[:panel] = "primary"
      else
        @rating_hash[:panel] = "default"
    end
    if logged_in?
      user_rating = @reference.ratings.where(user_id: current_user.id).first
      @rating_hash[:user_value] = user_rating[:value] unless user_rating.nil?
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
