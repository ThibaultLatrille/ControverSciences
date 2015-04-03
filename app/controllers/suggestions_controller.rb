class SuggestionsController < ApplicationController

  def show
    if params[:timeline_id]
      @suggestion = Suggestion.find_by( timeline_id: params[:timeline_id] )
    else
      @suggestion = Suggestion.find( params[:id] )
    end
  end

  def edit
    @suggestion = Suggestion.find( params[:id] )
  end

  def update
    @suggestion = Suggestion.find( params[:id] )
    if current_user.id = @suggestion.user_id
      if @suggestion.update( suggestion_params )
        render 'suggestions/show'
      else
        render 'suggestions/edit'
      end
    else
      render 'suggestions/show'
    end
  end

  def index
    @suggestions = Suggestion.order( created_at: :desc).all.page(params[:page]).per(50)
    @suggestion = Suggestion.new
    if logged_in? && !@suggestion.name
      @suggestion.name = current_user.name
    elsif !@suggestion.name
      @suggestion.name = "Un illustre Anonyme"
    end
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    if logged_in?
      @suggestion.user_id = current_user.id
    end
    if @suggestion.save
      flash[:success] = "Commentaire ajouté."
      redirect_to suggestions_path
    else
      @suggestions = Suggestion.order( :created_at).all.page(params[:page]).per(50)
      render 'index'
    end
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:id, :comment, :name, :email)
  end
end
