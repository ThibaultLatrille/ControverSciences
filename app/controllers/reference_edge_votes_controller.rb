class ReferenceEdgeVotesController < ApplicationController
  def create
    if logged_in?
      timeline_id = ReferenceEdge.select(:timeline_id).find(params[:id]).timeline_id
      vote = ReferenceEdgeVote.find_by(reference_edge_id: params[:id],
                                       category: params[:category],
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
        vote = ReferenceEdgeVote.new(reference_edge_id: params[:id],
                                     timeline_id: timeline_id,
                                     category: params[:category],
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
