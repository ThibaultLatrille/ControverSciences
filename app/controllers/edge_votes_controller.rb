class EdgeVotesController < ApplicationController
  def create
    if logged_in?
      vote = EdgeVote.find_by(edge_id: params[:id],
                                    user_id: current_user.id,
                                    value: params[:value] == "true" ? true : false)
      if vote
        begin
          vote.destroy!
          render body: nil, :status => 204, :content_type => 'text/html'
        rescue
          render body: nil, :status => 401, :content_type => 'text/html'
        end
      else
        vote = EdgeVote.new(edge_id: params[:id],
                                  user_id: current_user.id,
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
