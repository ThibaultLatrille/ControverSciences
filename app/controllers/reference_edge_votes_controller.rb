class ReferenceEdgeVotesController < ApplicationController
  def create
    if logged_in?
      vote = ReferenceEdgeVote.find_by(reference_edge_id: params[:id],
                              user_id: current_user.id,
                              value: params[:value] == "true" ? true : false)
      if vote
        begin
          vote.destroy!
          render :nothing => true, :status => 204
        rescue
          render :nothing => true, :status => 401
        end
      else
        vote = ReferenceEdgeVote.new(reference_edge_id: params[:id],
                            user_id: current_user.id,
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
