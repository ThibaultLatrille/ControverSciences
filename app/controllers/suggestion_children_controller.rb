class SuggestionChildrenController < ApplicationController
  def from_suggestion
    @suggestion_children = SuggestionChild.where( suggestion_id: params[:suggestion_id])
    respond_to do |format|
      format.js
    end
  end
end
