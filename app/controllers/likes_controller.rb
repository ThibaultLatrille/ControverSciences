class LikesController < ApplicationController
  def create
    like = Like.new(timeline_id: like_params,
                    ip: request.remote_ip )
    begin
      like.save
      flash[:success] = "Vous aimez cette controverse"
    rescue
      flash[:danger] = "Cette IP a déjà été utiliser pour aimer cette controverse"
    end
    redirect_to timeline_path( like_params )
  end

  private

  def like_params
    params.require(:id)
  end
end
