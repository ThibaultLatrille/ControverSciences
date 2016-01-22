class DeadLinksController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :index]
  before_action :admin_user, only: [:index, :destroy]

  def create
    dead_link = DeadLink.new({user_id:     current_user.id,
                              reference_id: params[:reference_id]})
    if dead_link.save
      flash[:success] = t('controllers.dead_link_ok')
    else
      flash[:danger] = t('controllers.dead_link_not_ok')
    end
    redirect_to_back
  end

  def destroy
    dead_link = DeadLink.find(params[:id])
    dead_link.destroy
    redirect_to_back
  end

  def index
    @dead_links = DeadLink.all
  end
end
