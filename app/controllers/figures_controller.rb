class FiguresController < ApplicationController
  def create
    figure = Figure.new
    flag = true
    if params[:reference_id]
      figure.reference_id = params[:reference_id]
    elsif params[:timeline_id]
      figure.timeline_id = params[:timeline_id]
    elsif params[:img_timeline_id]
      figure.img_timeline_id = params[:img_timeline_id]
    elsif params[:partner_id]
      figure.partner_id = params[:partner_id]
    elsif params[:profil_picture]
      figure.user_id = current_user.id
      figure.profil = true
    else
      flag = false
    end
    if current_user.admin && !params[:user_id].blank?
      figure.user_id = params[:user_id]
    else
      figure.user_id = current_user.id
    end
    figure.set_file_name
    figure.picture = params[:figure][:picture]
    if flag && figure.save
      respond_to do |format|
        format.json { render json: figure }
      end
    else
      respond_to do |format|
        format.json { render json: figure }
      end
    end
  end
end
