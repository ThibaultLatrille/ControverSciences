class PartnerLovesController < ApplicationController

  def create
    if logged_in?
      partner_love = PartnerLove.find_by(partner_id: partner_love_params,
                          user: current_user)
      if partner_love
        begin
          partner_love.destroy!
          render body: nil, :status => 204, :content_type => 'text/html'
        rescue
          render body: nil, :status => 401, :content_type => 'text/html'
        end
      else
        partner_love = PartnerLove.new(partner_id: partner_love_params,
                        user: current_user)
        begin
          partner_love.save!
          render body: nil, :status => 201, :content_type => 'text/html'
        rescue
          render body: nil, :status => 401, :content_type => 'text/html'
        end
      end
    else
      render body: nil, :status => 401, :content_type => 'text/html'
    end
  end

  private

  def partner_love_params
    params.require(:id)
  end
end
