class SuggestionsController < ApplicationController
  def show
    @suggestion = Suggestion.find(params[:id])
    if logged_in?
      @my_sug_likes = SuggestionVote.where(user_id: current_user.id, value: true).pluck(:suggestion_id)
    end
  end

  def edit
    @suggestion = Suggestion.find(params[:id])
  end

  def update
    @suggestion = Suggestion.find(params[:id])
    if current_user.id == @suggestion.user_id || current_user.admin
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
    if logged_in?
      @my_sug_likes = SuggestionVote.where(user_id: current_user.id, value: true).pluck(:suggestion_id)
    end
    @suggestions = Suggestion.order(created_at: :desc).page(params[:page]).per(25)
    @suggestion = Suggestion.new
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
      if logged_in?
        @my_sug_likes = SuggestionVote.where(user_id: current_user.id, value: true).pluck(:suggestion_id)
      end
      @suggestions = Suggestion.order(created_at: :desc).page(params[:page]).per(25)
      render 'index'
    end
  end

  def destroy
    sug = Suggestion.find(params[:id])
    if sug.user_id == current_user.id || current_user.admin
      sug.destroy
      redirect_to suggestions_path
    end
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:id, :comment, :name)
  end
end
