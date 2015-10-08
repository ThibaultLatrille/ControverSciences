class PartnerLovesController < ApplicationController

  def create
    if logged_in?
      partner_love = PartnerLove.find_by(partner_id: partner_love_params,
                          user: current_user)
      if partner_love
        begin
          partner_love.destroy!
          render :nothing => true, :status => 204
        rescue
          render :nothing => true, :status => 401
        end
      else
        partner_love = PartnerLove.new(partner_id: partner_love_params,
                        user: current_user)
        begin
          partner_love.save!
          render :nothing => true, :status => 201
        rescue
          render :nothing => true, :status => 401
        end
      end
    else
      render :nothing => true, :status => 401
    end
  end

  private

  def partner_love_params
    params.require(:id)
  end
end
