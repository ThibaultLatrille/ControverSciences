class PartnersController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit,  :update,:destroy]

  def index
    @partners = Partner.all
  end

  def new
    @partner = Partner.new
  end

  def edit
    @partner = Partner.find(params[:id])
  end

  def create
    @partner = Partner.new(partner_params)
    @partner.user_id = current_user.id
    if @partner.save
      redirect_to edit_partner_path(@partner)
    else
      render 'new'
    end
  end

  def update
    @partner = Partner.find(params[:id])
    @partner.update(partner_params)
    if partner_params[:delete_picture] == 'true'
      @partner.figure_id = nil
    elsif partner_params[:has_picture] == 'true'
      @partner.figure_id = Figure.order( :created_at ).where( user_id: current_user.id,
                                                              partner_id: @partner.id ).last.id
    end
    if @partner.save
      redirect_to partners_path
    else
      render 'edit'
    end
  end

  def suggest
  end

  def destroy
    Partner.find(params[:id]).destroy
    redirect_to partners_path
  end

  private

  def partner_params
    params.require(:partner).permit(:name, :description,
                                 :url, :why, :has_picture, :delete_picture)
  end
end
