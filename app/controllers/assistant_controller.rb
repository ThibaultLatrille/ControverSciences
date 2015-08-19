class AssistantController < ApplicationController
  include AssisstantHelper

  before_action :admin_user, only: [:view, :index, :users, :timelines, :profils]

  def view
  end

  def index
    pending_users = Hash[PendingUser.all.pluck( :user_id, :why)]
    @users = User.where( id: pending_users.keys  )
    @users.each do |user|
      user.why = pending_users[user.id]
    end
  end

  def users
    update_score_users
    flash[:success] = t('controllers.updated_score_users')
    redirect_to assistant_path
  end

  def timelines
    update_score_timelines
    flash[:success] = t('controllers.updated_score_timelines')
    redirect_to assistant_path
  end

  def profils
    update_all_profils
    flash[:success] = t('controllers.updated_profils')
    redirect_to assistant_path
  end
end
