class LikesController < ApplicationController
  before_action :logged_in_user, only: [:index, :destroy]

  def create
    if logged_in?
      like = Like.new(timeline_id: like_params,
                      user: current_user)
      begin
        like.save!
        render :nothing => true, :status => 200
      rescue
        render :nothing => true, :status => 409
      end
    else
      render :nothing => true, :status => 401
    end
  end

  def index
    @likes = Like.where(user_id: current_user.id)
  end

  def destroy
    like = Like.find(like_params)
    if like.user == current_user
      like.destroy
    end
    @likes = Like.where(user_id: current_user.id)
    render 'index'
  end

  private

  def like_params
    params.require(:id)
  end
end
