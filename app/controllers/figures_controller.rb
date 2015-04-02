class FiguresController < ApplicationController
  def create
    figure = Figure.new( user_id: current_user.id )
    flag = true
    if params[:reference_id]
      figure.reference_id = params[:reference_id]
    elsif params[:timeline_id]
      figure.timeline_id = params[:timeline_id]
    elsif params[:profil_picture]
      figure.user_id = current_user.id
      figure.profil = true
    else
      flag = false
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
