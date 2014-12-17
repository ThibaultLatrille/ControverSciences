class LikesController < ApplicationController
  def create
    if Like.create( timeline_id: like_params[:timeline_id],
                    ip: request.remote_ip)
      flash[:success] = "Vous aimez cette controverse"
    else
      flash[:danger] = "Vous aimez déjà cette controverse"
    end
    redirect_to timeline_path( like_params[:timeline_id] )
  end

  private

  def like_params
    params.require(:like).permit(:timeline_id)
  end
end
