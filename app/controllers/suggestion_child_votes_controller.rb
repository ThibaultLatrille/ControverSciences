class SuggestionChildVotesController < ApplicationController
  def add
    if params[:value] == "true"
      vote = SuggestionChildVote.new(suggestion_child_id: params[:id],
                    ip: request.remote_ip, value: true )
    else
      vote = SuggestionChildVote.new(suggestion_child_id: params[:id],
                    ip: request.remote_ip, value: false )
    end
    begin
      vote.save
      render :nothing => true, :status => 200
    rescue
      render :nothing => true, :status => 409
    end
  end

  private

  def suggestion_child_vote_params
    params.require(:vote).permit(:suggestion_child_id, :value)
  end
end