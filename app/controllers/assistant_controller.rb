class AssistantController < ApplicationController
  include AssisstantHelper

  before_action :admin_user, only: [:view, :index, :users, :timelines, :selection, :fitness, :profils]

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
    flash[:success] = "Les valeurs sélectives des utilisateurs sont à jour"
    redirect_to assistant_path
  end

  def timelines
    update_score_timelines
    flash[:success] = "Les valeurs sélectives des controverses sont à jour"
    redirect_to assistant_path
  end

  def fitness
    compute_fitness
    flash[:success] = "Les valeurs sélectives des analyses sont à jour"
    redirect_to assistant_path
  end

  def selection
    selection_events
    flash[:success] = "La sélection a opéré"
    redirect_to assistant_path
  end

  def profils
    update_all_profils
    flash[:success] = "Les profils ont été mis à jour"
    redirect_to assistant_path
  end
end