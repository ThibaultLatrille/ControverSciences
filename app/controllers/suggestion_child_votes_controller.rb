class SuggestionChildVotesController < ApplicationController
  def create
    if logged_in?
      vote = SuggestionChildVote.find_by(suggestion_child_id: params[:id],
                                    user_id:       current_user.id,
                                    value: params[:value] == "true" ? true : false)
      if vote
        begin
          vote.destroy!
          render body: nil, :status => 204, :content_type => 'text/html'
        rescue
          render body: nil, :status => 401, :content_type => 'text/html'
        end
      else
        vote = SuggestionChildVote.new(suggestion_child_id: params[:id],
                                  user_id:       current_user.id,
                                  value: params[:value] == "true" ? true : false)
        begin
          vote.save!
          render body: nil, :status => 201, :content_type => 'text/html'
        rescue
          render body: nil, :status => 401, :content_type => 'text/html'
        end
      end
    else
      render body: nil, :status => 401, :content_type => 'text/html'
    end
  end

  private

  def suggestion_child_vote_params
    params.require(:vote).permit(:suggestion_child_id, :value)
  end
end