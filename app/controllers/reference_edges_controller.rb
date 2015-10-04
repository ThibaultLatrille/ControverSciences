class ReferenceEdgesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def index
    @reference_edge = ReferenceEdge.new
    params[:original_reference_id] ||= params[:reference_id]
    set_index
  end

  def create
    reference_edges = []
    Array(params[:reference_edge][:from_ids]).each do |from_id|
      Array(params[:reference_edge][:target]).each do |target_id|
      reference_edges << ReferenceEdge.new(user_id: current_user.id,
                                           reference_id: from_id,
                                           timeline_id: reference_edge_params[:timeline_id],
                                           weight: 1, target: target_id)
      end
    end
    reference_edges.map{ |e| e.save }
    @reference_edge = ReferenceEdge.new
    if reference_edges.count == 0
      @reference_edge.errors.add(:base, t('activerecord.attributes.reference_edge.target'))
    end
    params[:timeline_id] = reference_edge_params[:timeline_id]
    params[:reference_id] = reference_edge_params[:reference_id]
    set_index
    render 'index'
  end

  def set_index
    year = Reference.select(:year).find(params[:reference_id]).year
    reference_edges = ReferenceEdge.order(balance: :desc).where(timeline_id: params[:timeline_id])
                           .where("reference_id = ? OR target = ?",
                                  params[:reference_id],
                                  params[:reference_id])
    @ref_edges_target_older = ReferenceEdge.order(balance: :desc)
                                 .where(timeline_id: params[:timeline_id])
                                 .where(reference_id: params[:reference_id])
    @ref_edges_target_newer = ReferenceEdge.order(balance: :desc)
                                  .where(timeline_id: params[:timeline_id])
                                  .where(target: params[:reference_id])
    reference_ids = reference_edges.map { |e| [e.target, e.reference_id] }
    reference_ids << params[:reference_id].to_i
    reference_names = Reference.order(year: :desc).where(timeline_id: params[:timeline_id])
                          .where.not(id: reference_ids.flatten.uniq)
    @reference_names_newer = reference_names.where('year >= :ref_year', :ref_year => year).pluck(:title, :year, :id)
    @reference_names_older = reference_names.where('year <= :ref_year', :ref_year => year).pluck(:title, :year, :id)
    @my_vote_likes = ReferenceEdgeVote.where(user_id: current_user.id, value: true,
                                             reference_edge_id: reference_edges.map { |e| e.id }).pluck(:reference_edge_id)
    @my_vote_dislikes = ReferenceEdgeVote.where(user_id: current_user.id, value: false,
                                                reference_edge_id: reference_edges.map { |e| e.id }).pluck(:reference_edge_id)
  end

  private

  def reference_edge_params
    params.require(:reference_edge).permit(:weight, :reference_id, :direction, :target, :timeline_id, :category)
  end

end
