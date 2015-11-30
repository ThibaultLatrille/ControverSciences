class EdgesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def index
    @edge = Edge.new
    set_index
  end

  def create
    edges = []
    params[:edge][:target] ||= []
    params[:edge][:target].each do |target_id|
      edges << Edge.new(user_id: current_user.id,
                       timeline_id: edge_params[:timeline_id],
                       weight: 1, target: target_id)
    end
    edges.map{ |e| e.save }
    @edge = Edge.new
    if edges.count == 0
      @edge.errors.add(:base, t('activerecord.attributes.edge.target'))
    end
    params[:timeline_id] = edge_params[:timeline_id]
    set_index
    render 'index'
  end

  def set_index
    @edges = Edge.order( balance: :desc).where("timeline_id = ? OR target = ?",
                                               params[:timeline_id],
                                               params[:timeline_id])
    timeline_ids = @edges.map{ |e| [e.target, e.timeline_id] }
    timeline_ids << params[:timeline_id].to_i
    @timeline_names = Timeline.order(:name).where.not( id: timeline_ids.flatten.uniq, private: true ).pluck(:name, :id)
    @my_vote_likes = EdgeVote.where(user_id: current_user.id, value: true,
                                    edge_id: @edges.map{|e| e.id}).pluck(:edge_id)
    @my_vote_dislikes = EdgeVote.where(user_id: current_user.id, value: false,
                                       edge_id: @edges.map{|e| e.id}).pluck(:edge_id)
  end

  private

  def edge_params
    params.require(:edge).permit(:weight, :timeline_id, :target, :value)
  end
end
