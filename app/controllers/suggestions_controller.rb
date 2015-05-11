class SuggestionsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]

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
    if current_user.id == @suggestion.user_id
      @suggestion.comment = suggestion_params[:comment]
      @suggestion.name = suggestion_params[:name]
      if @suggestion.save
        render 'suggestions/show'
      else
        render 'suggestions/edit'
      end
    else
      render 'suggestions/show'
    end
  end

  def index
    if params[:filter] == "debate"
      @suggestions = Suggestion.order( created_at: :desc).where.not( timeline_id: nil ).page(params[:page]).per(50)
    else
      @suggestions = Suggestion.order( created_at: :desc).where( timeline_id: nil ).page(params[:page]).per(50)
    end
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
    if suggestion_params[:debate] == "true"
      @suggestion.timeline_id = 0
    end
    if @suggestion.save
      flash[:success] = "Commentaire ajouté."
      redirect_to suggestions_path
    else
      @suggestions = Suggestion.order( :created_at).all.page(params[:page]).per(50)
      render 'index'
    end
  end

  def destroy
    sug = Suggestion.find(params[:id])
    if sug.user_id == current_user.id
      sug.destroy
      redirect_to suggestions_path
    end
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:id, :comment, :name, :email, :debate)
  end
end
