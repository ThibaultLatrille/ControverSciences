class EdgesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def index
    @edges = Edge.order( balance: :desc).where("timeline_id = ? OR target = ?",
                        params[:timeline_id],
                        params[:timeline_id])
    timeline_ids = @edges.map{ |e| [e.target, e.timeline_id] }
    timeline_ids << params[:timeline_id].to_i
    @timeline_names = Timeline.order(:name).all.where.not( id: timeline_ids.flatten.uniq ).pluck(:name, :id)
    @my_vote_likes = EdgeVote.where(user_id: current_user.id, value: true,
                                    edge_id: @edges.map{|e| e.id}).pluck(:edge_id)
    @my_vote_dislikes = EdgeVote.where(user_id: current_user.id, value: false,
                                    edge_id: @edges.map{|e| e.id}).pluck(:edge_id)
  end

  def create
        Edge.create!(user_id: current_user.id,
                    timeline_id: edge_params[:timeline_id],
                        weight: 1, target: edge_params[:target])
    redirect_to edges_path(timeline_id: edge_params[:timeline_id])
  end

  private

  def edge_params
    params.require(:edge).permit(:weight, :timeline_id, :target, :value)
  end
end
