class EdgeVotesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def create
    EdgeVote.where( user_id: current_user).where(timeline_id: edge_vote_params[:timeline_id],
                                                 target: edge_vote_params[:target]).destroy_all
    EdgeVote.where( user_id: current_user).where(timeline_id: edge_vote_params[:target],
                                                 target: edge_vote_params[:timeline_id]).destroy_all
    case edge_vote_params[:value].to_i
      when 0
      EdgeVote.create!(user_id: current_user.id, reversible: false,
                  timeline_id: edge_vote_params[:timeline_id],
                  target: edge_vote_params[:target])
      redirect_to edges_path(timeline_id: edge_vote_params[:timeline_id])
      when 1
      EdgeVote.create!(user_id: current_user.id, reversible: false,
                  timeline_id: edge_vote_params[:target],
                  target: edge_vote_params[:timeline_id])
      redirect_to edges_path(timeline_id: edge_vote_params[:timeline_id])
      when 2
      EdgeVote.create!(user_id: current_user.id, reversible: true,
                  timeline_id: edge_vote_params[:target],
                  target: edge_vote_params[:timeline_id])
      EdgeVote.create!(user_id: current_user.id, reversible: true,
                  timeline_id: edge_vote_params[:timeline_id],
                  target: edge_vote_params[:target])
      redirect_to edges_path(timeline_id: edge_vote_params[:timeline_id])
      else
        redirect_to edges_path(timeline_id: edge_vote_params[:timeline_id])
    end
  end

  private

  def edge_vote_params
    params.require(:edge_vote).permit(:timeline_id, :target, :value)
  end
end
