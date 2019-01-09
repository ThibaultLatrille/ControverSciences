class SuggestionVotesController < ApplicationController
  def create
    if logged_in?
      vote = SuggestionVote.find_by(suggestion_id: params[:id],
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
        vote = SuggestionVote.new(suggestion_id: params[:id],
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
end