class LikesController < ApplicationController
  def add
    like = Like.new(timeline_id: like_params,
                    ip: request.remote_ip )
    begin
      like.save
      render :nothing => true, :status => 200
    rescue
      render :nothing => true, :status => 409
    end
  end

  private

  def like_params
    params.require(:id)
  end
end
