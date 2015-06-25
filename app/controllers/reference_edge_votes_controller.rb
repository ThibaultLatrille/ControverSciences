class ReferenceEdgeVotesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def create
    ReferenceEdgeVote.where( user_id: current_user).where(reference_id: reference_edge_vote_params[:reference_id],
                                                 target: reference_edge_vote_params[:target]).destroy_all
    ReferenceEdgeVote.where( user_id: current_user).where(reference_id: reference_edge_vote_params[:target],
                                                 target: reference_edge_vote_params[:reference_id]).destroy_all
    case reference_edge_vote_params[:value].to_i
      when 0
      ReferenceEdgeVote.create!(user_id: current_user.id, reversible: false,
                  reference_id: reference_edge_vote_params[:reference_id],
                  timeline_id: reference_edge_vote_params[:timeline_id],
                  target: reference_edge_vote_params[:target])
      redirect_to reference_edges_path(reference_id: reference_edge_vote_params[:reference_id],
                                       timeline_id: reference_edge_vote_params[:timeline_id])
      when 1
      ReferenceEdgeVote.create!(user_id: current_user.id, reversible: false,
                  reference_id: reference_edge_vote_params[:target],
                  timeline_id: reference_edge_vote_params[:timeline_id],
                  target: reference_edge_vote_params[:reference_id])
      redirect_to reference_edges_path(reference_id: reference_edge_vote_params[:reference_id],
                                       timeline_id: reference_edge_vote_params[:timeline_id])
      when 2
      ReferenceEdgeVote.create!(user_id: current_user.id, reversible: true,
                  reference_id: reference_edge_vote_params[:target],
                  timeline_id: reference_edge_vote_params[:timeline_id],
                  target: reference_edge_vote_params[:reference_id])
      ReferenceEdgeVote.create!(user_id: current_user.id, reversible: true,
                  reference_id: reference_edge_vote_params[:reference_id],
                  timeline_id: reference_edge_vote_params[:timeline_id],
                  target: reference_edge_vote_params[:target])
      redirect_to reference_edges_path(reference_id: reference_edge_vote_params[:reference_id],
                                       timeline_id: reference_edge_vote_params[:timeline_id])
      else
        redirect_to reference_edges_path(reference_id: reference_edge_vote_params[:reference_id],
                                          timeline_id: reference_edge_vote_params[:timeline_id])
    end
  end

  private

  def reference_edge_vote_params
    params.require(:reference_edge_vote).permit(:reference_id, :target, :value, :timeline_id)
  end
end
