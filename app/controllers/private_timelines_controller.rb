class PrivateTimelinesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create]

  def index
    @private_timeline = PrivateTimeline.new
    set_index
  end


  def create
    private_timelines = []
    params[:private_timeline][:user_id] ||= []
    params[:private_timeline][:user_id].each do |user_id|
      private_timelines << PrivateTimeline.new(user_id: user_id,
                       timeline_id: private_timeline_params[:timeline_id] )
    end
    private_timelines.map{ |e| e.save }
    @private_timeline = PrivateTimeline.new
    if private_timelines.count == 0
      @private_timeline.errors.add(:base, t('activerecord.attributes.edge.target'))
    end
    params[:timeline_id] = private_timeline_params[:timeline_id]
    set_index
    render 'index'
  end

  def set_index
    @private_timelines = PrivateTimeline.includes(:user).where(timeline_id: params[:timeline_id])
    @user_names = User.order(:name).all.where.not( id: @private_timelines.map{ |u| u.user_id } ).pluck(:name, :id)
  end

  private

  def private_timeline_params
    params.require(:private_timeline).permit(:user_id, :timeline_id)
  end
end
