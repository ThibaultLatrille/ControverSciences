class SuggestionChildVotesController < ApplicationController

  def create
    if logged_in?
      vote = SuggestionChildVote.find_by(suggestion_child_id: params[:id],
                                    user_id:       current_user.id,
                                    value: params[:value] == "true" ? true : false)
      if vote
        begin
          vote.destroy!
          render :nothing => true, :status => 204
        rescue
          render :nothing => true, :status => 401
        end
      else
        vote = SuggestionChildVote.new(suggestion_child_id: params[:id],
                                  user_id:       current_user.id,
                                  value: params[:value] == "true" ? true : false)
        begin
          vote.save!
          render :nothing => true, :status => 201
        rescue
          render :nothing => true, :status => 401
        end
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