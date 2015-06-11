class SuggestionsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]

  def show
    if params[:timeline_id]
      @suggestion = Suggestion.find_by( timeline_id: params[:timeline_id] )
    else
      @suggestion = Suggestion.find( params[:id] )
      if logged_in?
        @my_sug_likes = SuggestionVote.where(user_id: current_user.id, value: true ).pluck(:suggestion_id)
        @my_sug_dislikes = SuggestionVote.where(user_id: current_user.id, value: false ).pluck(:suggestion_id)
      end
    end
  end

  def edit
    @suggestion = Suggestion.find( params[:id] )
  end

  def update
    @suggestion = Suggestion.find( params[:id] )
    if current_user.id == @suggestion.user_id
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
      @suggestions = Suggestion.order( created_at: :desc).where.not( timeline_id: nil ).page(params[:page]).per(50)
    else
      if logged_in?
        @my_sug_likes = SuggestionVote.where(user_id: current_user.id, value: true ).pluck(:suggestion_id)
        @my_sug_dislikes = SuggestionVote.where(user_id: current_user.id, value: false ).pluck(:suggestion_id)
      end
      @suggestions = Suggestion.order( created_at: :desc).where( timeline_id: nil ).page(params[:page]).per(50)
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
      @suggestions = Suggestion.order( :created_at).all.page(params[:page]).per(50)
      render 'index'
    end
  end

  def destroy
    sug = Suggestion.find(params[:id])
    if sug.user_id == current_user.id && sug.timeline_id != 0
      sug.destroy
      redirect_to suggestions_path
    end
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:id, :comment)
  end
end
