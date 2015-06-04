class SuggestionChildrenController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]

  def from_suggestion
    @suggestion_children = SuggestionChild.order( :created_at ).where( suggestion_id: params[:suggestion_id])
    respond_to do |format|
      format.js
    end
  end

  def show
    @suggestion_child = SuggestionChild.find( params[:id] )
    @suggestion = Suggestion.find( @suggestion_child.suggestion_id )
  end

  def edit
    @suggestion_child = SuggestionChild.find( params[:id] )
    @suggestion = Suggestion.find( @suggestion_child.suggestion_id )
  end

  def update
    @suggestion_child = SuggestionChild.find( params[:id] )
    @suggestion = Suggestion.find( @suggestion_child.suggestion_id )
    if current_user.id == @suggestion_child.user_id
      @suggestion_child.comment = suggestion_child_params[:comment]
      if @suggestion_child.save
        render 'suggestion_children/show'
      else
        render 'suggestion_children/edit'
      end
    else
      render 'suggestion_children/show'
    end
  end

  def create
    @suggestion_child = SuggestionChild.new( suggestion_child_params)
    @suggestion_child.user_id = current_user.id
    if @suggestion_child.save
      flash[:success] = "Commentaire ajouté."
      redirect_to suggestion_child_path( @suggestion_child.id )
    else
      @suggestion = Suggestion.find(suggestion_child_params[:suggestion_id])
      render 'new'
    end
  end

  def destroy
    sug = SuggestionChild.find(params[:id])
    if sug.user_id == current_user.id
      sug.destroy
      redirect_to suggestions_path
    end
  end

  private

  def suggestion_child_params
    params.require(:suggestion_child).permit(:id, :comment, :suggestion_id)
  end

end
