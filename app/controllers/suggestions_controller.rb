class SuggestionsController < ApplicationController
  before_action :redirect_to_home

  def show
    if params[:timeline_id]
      @suggestion = Suggestion.find_by( timeline_id: params[:timeline_id] )
    else
      @suggestion = Suggestion.find( params[:id] )
      if logged_in?
        @my_sug_likes = SuggestionVote.where(user_id: current_user.id, value: true ).pluck(:suggestion_id)
      end
    end
  end

  def edit
    @suggestion = Suggestion.find( params[:id] )
  end

  def update
    @suggestion = Suggestion.find( params[:id] )
    if current_user.id == @suggestion.user_id || current_user.admin
      @suggestion.comment = suggestion_params[:comment]
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
      @suggestions = Suggestion.order( created_at: :desc).where.not( timeline_id: nil ).page(params[:page]).per(25)
    else
      if logged_in?
        @my_sug_likes = SuggestionVote.where(user_id: current_user.id, value: true ).pluck(:suggestion_id)
      end
      @suggestions = Suggestion.order( created_at: :desc).where( timeline_id: nil ).page(params[:page]).per(25)
    end
    @suggestion = Suggestion.new
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    @suggestion.user_id = current_user.id
    @suggestion.timeline_id = nil
    if @suggestion.save
      flash[:success] = "Commentaire ajouté."
      redirect_to suggestions_path
    else
      @my_sug_likes = SuggestionVote.where(user_id: current_user.id, value: true ).pluck(:suggestion_id)
      @suggestions = Suggestion.order( created_at: :desc).where( timeline_id: nil ).page(params[:page]).per(25)
      render 'index'
    end
  end

  def destroy
    sug = Suggestion.find(params[:id])
    if (sug.user_id == current_user.id || current_user.admin) && (sug.timeline_id != 0)
      sug.destroy
      redirect_to suggestions_path
    end
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:id, :comment)
  end
end
