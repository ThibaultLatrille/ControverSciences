class EdgesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def index
    @timeline_names = Timeline.select(:id, :name).order(:name).all.where.not( id: params[:timeline_id])
    @edges = Edge.where( timeline_id: params[:timeline_id]).pluck(:target)
  end

  def create
    edges = []
    Edge.where(timeline_id: edge_params[:timeline_id]).destroy_all
    params[:edge][:target_ids].each do |target_id|
      edges << Edge.new(user_id: current_user.id, timeline_id: edge_params[:timeline_id],
                        weight: 1, target: target_id)
    end
    Edge.import edges
    redirect_to timeline_path(edge_params[:timeline_id])
  end

  private

  def edge_params
    params.require(:edge).permit(:weight, :timeline_id)
  end
end
