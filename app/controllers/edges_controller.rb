class EdgesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def index
    @edges = Edge.where("timeline_id = ? OR target = ?",
                        params[:timeline_id],
                        params[:timeline_id]).where.not(
                        "reversible = ? AND target = ?",
                        true,
                        params[:timeline_id])
    timeline_ids = @edges.map{ |e| [e.target, e.timeline_id] }.flatten.uniq
    @timeline_names = Timeline.order(:name).all.where.not( id: timeline_ids ).pluck(:name, :id)
  end

  def create
    case edge_params[:value].to_i
      when 0
        Edge.create!(user_id: current_user.id, reversible: false,
                    timeline_id: edge_params[:timeline_id],
                        weight: 1, target: edge_params[:target])
      when 1
        Edge.create!(user_id: current_user.id, reversible: false,
                    timeline_id: edge_params[:target],
                    weight: 1, target: edge_params[:timeline_id])
      when 2
        Edge.create!(user_id: current_user.id, reversible: true,
                    timeline_id: edge_params[:target],
                    weight: 1, target: edge_params[:timeline_id])
        Edge.create!(user_id: current_user.id, reversible: true,
                    timeline_id: edge_params[:timeline_id],
                    weight: 1, target: edge_params[:target])
    end
    redirect_to edges_path(timeline_id: edge_params[:timeline_id])
  end

  private

  def edge_params
    params.require(:edge).permit(:weight, :timeline_id, :target, :value)
  end
end
