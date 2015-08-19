class RatingsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    if params[:update]
      @rating = Rating.find_by(user_id: current_user.id,reference_id: rating_params[:reference_id])
      if rating_params[:value] == "none"
        @rating.destroy
        flash[:info] = t('controllers.vote_ok')
        redirect_to controller: 'references', action: 'show', id: rating_params[:reference_id]
      elsif @rating.update( {value: rating_params[:value]})
        flash[:info] = t('controllers.vote_ok')
        redirect_to controller: 'references', action: 'show', id: rating_params[:reference_id]
      else
        flash[:danger] = t('controllers.impossible_action')
        redirect_to controller: 'references', action: 'show', id: rating_params[:reference_id]
      end
    else
      @rating = Rating.new({user_id: current_user.id,
                            timeline_id: rating_params[:timeline_id],
                            reference_id: rating_params[:reference_id], value: rating_params[:value]})
      if @rating.save
        flash[:info] = t('controllers.vote_ok')
        redirect_to reference_url( rating_params[:reference_id] )
      else
        flash[:info] = t('controllers.no_vote_selected')
        redirect_to reference_url( rating_params[:reference_id] )
      end
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:reference_id, :timeline_id, :value)
  end
end
