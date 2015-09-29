class SuggestionVotesController < ApplicationController
  before_action :redirect_to_home

  def create
    if logged_in?
      vote = SuggestionVote.find_by(suggestion_id: params[:id],
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
        vote = SuggestionVote.new(suggestion_id: params[:id],
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
end