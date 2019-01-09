class LikesController < ApplicationController
  before_action :logged_in_user, only: [:index, :destroy]

  def create
    if logged_in?
      like = Like.find_by(timeline_id: like_params,
                   user: current_user)
      if like
        begin
          like.destroy!
          render body: nil, :status => 204, :content_type => 'text/html'
        rescue
          render body: nil, :status => 401, :content_type => 'text/html'
        end
      else
        like = Like.new(timeline_id: like_params,
                        user: current_user)
        begin
          like.save!
          render body: nil, :status => 201, :content_type => 'text/html'
        rescue
          render body: nil, :status => 401, :content_type => 'text/html'
        end
      end
    else
      render body: nil, :status => 401, :content_type => 'text/html'
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
