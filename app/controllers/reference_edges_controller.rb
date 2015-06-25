class ReferenceEdgesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def index
    @reference_edges = ReferenceEdge.where("reference_id = ? OR target = ?",
                        params[:reference_id],
                        params[:reference_id]).where.not(
                        "reversible = ? AND target = ?",
                        true,
                        params[:reference_id])
    reference_ids = @reference_edges.map{ |e| [e.target, e.reference_id] }.flatten.uniq
    @reference_names = Timeline.order(:name).all.where.not( id: reference_ids ).pluck(:name, :id)
  end

  def create
    case reference_edge_params[:value].to_i
      when 0
        ReferenceEdge.create!(user_id: current_user.id, reversible: false,
                    reference_id: reference_edge_params[:reference_id],
                    timeline_id: reference_edge_params[:timeline_id],
                        weight: 1, target: reference_edge_params[:target])
      when 1
        ReferenceEdge.create!(user_id: current_user.id, reversible: false,
                    reference_id: reference_edge_params[:target],
                    timeline_id: reference_edge_params[:timeline_id],
                    weight: 1, target: reference_edge_params[:reference_id])
      when 2
        ReferenceEdge.create!(user_id: current_user.id, reversible: true,
                    reference_id: reference_edge_params[:target],
                    timeline_id: reference_edge_params[:timeline_id],
                    weight: 1, target: reference_edge_params[:reference_id])
        ReferenceEdge.create!(user_id: current_user.id, reversible: true,
                    reference_id: reference_edge_params[:reference_id],
                    timeline_id: reference_edge_params[:timeline_id],
                    weight: 1, target: reference_edge_params[:target])
    end
    redirect_to reference_edges_path(reference_id: reference_edge_params[:reference_id],
                                     timeline_id: reference_edge_params[:timeline_id])
  end

  private

  def reference_edge_params
    params.require(:edge).permit(:weight, :reference_id, :target, :value, :timeline_id)
  end
end
