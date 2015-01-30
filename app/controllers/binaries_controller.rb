class BinariesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    if params[:update]
      @binary = Binary.find_by(user_id: current_user.id,reference_id: binary_params[:reference_id])
      if binary_params[:value] == "none"
        @binary.destroy
        flash[:info] = "Votre avis a été supprimé"
        redirect_to controller: 'references', action: 'show', id: binary_params[:reference_id]
      elsif @binary.update( {value: binary_params[:value]})
        case binary_params[:value]
          when 1 || 2
            flash[:info] = "ZZbrraa, comment vous l'avez défoncé la référence !"
          when 3
            flash[:info] = "Ca va, vous vous mouillez pas trop !"
          else
            flash[:info] = "Mais quelle éloge de cette référence !"
        end
        redirect_to controller: 'references', action: 'show', id: binary_params[:reference_id]
      else
        flash[:danger] = "Echec"
        redirect_to controller: 'references', action: 'show', id: binary_params[:reference_id]
      end
    else
      @binary = Binary.new({user_id: current_user.id,
                            timeline_id: binary_params[:timeline_id],
                            reference_id: binary_params[:reference_id], value: binary_params[:value]})
      if @binary.save
        case binary_params[:value]
          when 1 || 2
            flash[:info] = "ZZbrraa, comment vous l'avez défoncé la référence !"
          when 3
            flash[:info] = "Ca va, vous vous mouillez pas trop !"
          else
            flash[:info] = "Mais quelle éloge de cette référence !"
        end
        redirect_to reference_url( binary_params[:reference_id] )
      else
        redirect_to root_url
      end
    end
  end

  private

  def binary_params
    params.require(:binary).permit(:reference_id, :timeline_id, :value)
  end
end
