class ReferenceEdgesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def index
    @reference_edges = ReferenceEdge.where( timeline_id: params[:timeline_id] )
                        .where("reference_id = ? OR target = ?",
                        params[:reference_id],
                        params[:reference_id])
    reference_ids = @reference_edges.map{ |e| [e.target, e.reference_id] }
    reference_ids << params[:reference_id].to_i
    @reference_names = Reference.order(:title).where( timeline_id: params[:timeline_id] )
                                              .where.not( id: reference_ids.flatten.uniq )
                                              .pluck(:title, :id)
    @my_vote_likes = ReferenceEdgeVote.where(user_id: current_user.id, value: true,
                                        reference_edge_id: @reference_edges.map{|e| e.id}).pluck(:reference_edge_id, :category)
    @my_vote_dislikes = ReferenceEdgeVote.where(user_id: current_user.id, value: false,
                                        reference_edge_id: @reference_edges.map{|e| e.id}).pluck(:reference_edge_id, :category)
  end

  def create
    ReferenceEdge.create!(user_id: current_user.id, reversible: false,
                          category: reference_edge_params[:category],
                reference_id: reference_edge_params[:reference_id],
                timeline_id: reference_edge_params[:timeline_id],
                    weight: 1, target: reference_edge_params[:target])
    redirect_to reference_edges_path(reference_id: reference_edge_params[:reference_id],
                                     timeline_id: reference_edge_params[:timeline_id])
  end

  private

  def reference_edge_params
    params.require(:reference_edge).permit(:weight, :reference_id, :target, :timeline_id, :category)
  end
end
