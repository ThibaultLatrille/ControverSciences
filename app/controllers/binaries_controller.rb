class BinariesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    if params[:update]
      @binary = Binary.find_by(user_id: current_user.id,reference_id: binary_params[:reference_id])
      if binary_params[:value] == "none"
        @binary.destroy
        flash[:info] = t('controllers.vote_ok')
        redirect_to controller: 'references', action: 'show', id: binary_params[:reference_id]
      elsif @binary.update( {value: binary_params[:value]})
        flash[:info] = t('controllers.vote_ok')
        redirect_to controller: 'references', action: 'show', id: binary_params[:reference_id]
      else
        flash[:danger] = t('controllers.impossible_edit')
        redirect_to controller: 'references', action: 'show', id: binary_params[:reference_id]
      end
    else
      @binary = Binary.new({user_id: current_user.id,
                            timeline_id: binary_params[:timeline_id],
                            reference_id: binary_params[:reference_id], value: binary_params[:value]})
      @binary.frame_id = Frame.select(:id).find_by(timeline_id: @binary.timeline_id, best: true).id
      if @binary.save
        flash[:info] = t('controllers.vote_ok')
        redirect_to reference_url( binary_params[:reference_id] )
      else
        flash[:info] = t('controllers.no_vote_selected')
        redirect_to reference_url( binary_params[:reference_id] )
      end
    end
  end

  private

  def binary_params
    params.require(:binary).permit(:reference_id, :timeline_id, :value)
  end
end
