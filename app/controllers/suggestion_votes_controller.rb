class SuggestionVotesController < ApplicationController
  def add
    if params[:value] == "true"
      vote = SuggestionVote.new(suggestion_id: params[:id],
                    ip: request.remote_ip, value: true )
    else
      vote = SuggestionVote.new(suggestion_id: params[:id],
                    ip: request.remote_ip, value: false )
    end
    begin
      vote.save
      render :nothing => true, :status => 200
    rescue
      render :nothing => true, :status => 409
    end
  end
end