class SuggestionChildrenController < ApplicationController
  def from_suggestion
    @suggestion_children = SuggestionChild.order( :created_at ).where( suggestion_id: params[:suggestion_id])
    respond_to do |format|
      format.js
    end
  end

  def new
  end

  def create
    @suggestion_child = SuggestionChild.new(suggestion_child_params)
    if logged_in?
      @suggestion_child.user_id = current_user.id
    end
    if @suggestion_child.save
      flash[:success] = "Commentaire ajouté."
      redirect_to suggestions_path
    else
      @suggestion = Suggestion.find(suggestion_child_params[:suggestion_id])
      render 'new'
    end
  end

  private

  def suggestion_child_params
    params.require(:suggestion_child).permit(:comment, :name, :suggestion_id, :email)
  end

end
