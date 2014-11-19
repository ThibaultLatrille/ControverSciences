class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ReferencesHelper

  private

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Vous devez vous connecter/inscrire pour explorer ce recoin de ControverSciences"
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    flash[:danger] = "Vous devez être Admin pour accéder à cette page"
    redirect_to(root_url) unless current_user.admin?
  end

  def tags_hash
    {"planet" => "Environement", "biology" => "Biologie", "immunity" => "Immunité et santé",
     "pharmacy" => "Médicaments", "animal" => "Animaux", "plant" => "Végétaux",
     "space" => "Espace", "physics" => "Physique", "chemistry" => "Chimie",
     "economy" => "Economie et Finance", "social" => "Sciences sociales",
     "pie" => "Mathématiques"}
  end
end
