class SuggestionChildVotesController < ApplicationController
  def create
    if logged_in?
      if params[:value] == "true"
        vote = SuggestionChildVote.new(suggestion_child_id: params[:id],
                                       user_id:             current_user.id, value: true)
      else
        vote = SuggestionChildVote.new(suggestion_child_id: params[:id],
                                       user_id:             current_user.id, value: false)
      end
      begin
        vote.save!
        render :nothing => true, :status => 200
      rescue
        render :nothing => true, :status => 409
      end
    else
      render :nothing => true, :status => 401
    end
  end

  private

  def suggestion_child_vote_params
    params.require(:vote).permit(:suggestion_child_id, :value)
  end
end