class RatingsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    if params[:update]
      @rating = Rating.find_by(user_id: current_user.id,reference_id: rating_params[:reference_id])
      if rating_params[:value] == "none"
        @rating.destroy
        flash[:info] = "Votre avis a été supprimé"
        redirect_to controller: 'references', action: 'show', id: rating_params[:reference_id]
      elsif @rating.update( {value: rating_params[:value]})
        case rating_params[:value]
          when 1 || 2
            flash[:info] = "ZZbrraa, comment vous l'avez défoncé la référence !"
          when 3
            flash[:info] = "Ca va, vous vous mouillez pas trop !"
          else
            flash[:info] = "Mais quelle éloge de cette référence !"
        end
        redirect_to controller: 'references', action: 'show', id: rating_params[:reference_id]
      else
        flash[:danger] = "Echec"
        redirect_to controller: 'references', action: 'show', id: rating_params[:reference_id]
      end
    else
      @rating = Rating.new({user_id: current_user.id,
                            timeline_id: rating_params[:timeline_id],
                            reference_id: rating_params[:reference_id], value: rating_params[:value]})
      if @rating.save
        case rating_params[:value]
          when 1 || 2
            flash[:info] = "ZZbrraa, comment vous l'avez défoncé la référence !"
          when 3
            flash[:info] = "Ca va, vous vous mouillez pas trop !"
          else
            flash[:info] = "Mais quelle éloge de cette référence !"
        end
        redirect_to reference_url( rating_params[:reference_id] )
      else
        redirect_to root_url
      end
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:reference_id, :timeline_id, :value)
  end
end
