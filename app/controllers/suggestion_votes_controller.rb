class SuggestionVotesController < ApplicationController
  def create
    if logged_in?
      if params[:value] == "true"
        vote = SuggestionVote.new(suggestion_id: params[:id],
                                  user_id:       current_user.id, value: true)
      else
        vote = SuggestionVote.new(suggestion_id: params[:id],
                                  user_id:       current_user.id, value: false)
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
end