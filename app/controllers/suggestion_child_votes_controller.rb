class SuggestionChildVotesController < ApplicationController
  def create
    if suggestion_child_vote_params[:value] == "true"
      vote = SuggestionChildVote.new(suggestion_child_id: suggestion_child_vote_params[:suggestion_child_id],
                    ip: request.remote_ip, value: true )
    else
      vote = SuggestionChildVote.new(suggestion_child_id: suggestion_child_vote_params[:suggestion_child_id],
                    ip: request.remote_ip, value: false )
    end
    begin
      vote.save
      flash[:success] = "Votre vote a été pris en compte."
    rescue
      flash[:danger] = "Vous avez déjà voté."
    end
    redirect_to suggestions_path
  end

  private

  def suggestion_child_vote_params
    params.require(:vote).permit(:suggestion_child_id, :value)
  end
end