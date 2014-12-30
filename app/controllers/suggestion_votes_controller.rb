class SuggestionVotesController < ApplicationController
  def create
    if suggestion_vote_params[:value] == "true"
      vote = SuggestionVote.new(suggestion_id: suggestion_vote_params[:suggestion_id],
                    ip: request.remote_ip, value: true )
    else
      vote = SuggestionVote.new(suggestion_id: suggestion_vote_params[:suggestion_id],
                    ip: request.remote_ip, value: false )
    end
    puts vote.inspect
    begin
      vote.save
      flash[:success] = "Votre vote a été prit en compte"
    rescue
      flash[:danger] = "Cette IP a déjà été utilisée pour voter à cette suggestion"
    end
    redirect_to suggestions_path
  end

  private

  def suggestion_vote_params
    params.require(:vote).permit(:suggestion_id, :value)
  end
end