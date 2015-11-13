class PrivateTimelinesController < ApplicationController
  before_action :logged_in_user, only: [:index, :create, :add_current_user]

  def index
    @private_timeline = PrivateTimeline.new
    set_index
  end

  def add_current_user
    pt = PrivateTimeline.new(user_id: current_user.id,
                        timeline_id: params[:timeline_id] )
    if pt.save
      flash[:success] = t('controllers.add_current_user')
    end
    redirect_to private_timelines_path(timeline_id: params[:timeline_id])
  end

  def create
    count = 0
    params[:private_timeline][:user_id] ||= []
    params[:private_timeline][:user_id].each do |user_id|
      private_timeline =  PrivateTimeline.new(user_id: user_id,
                        timeline_id: private_timeline_params[:timeline_id] )
      if private_timeline.save
        if Rails.env.production?
          mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
          @invitation = Invitation.new(target_email: private_timeline.user.email,
                                       timeline_id: private_timeline.timeline_id,
                                       target_name: private_timeline.user.name)
          subject = "#{@invitation.target_name}, #{t('controllers.particiate')}"
          message = {
              :subject =>  (CGI.unescapeHTML subject),
              :from=>"ControverSciences <invitation@controversciences.org>",
              :to => @invitation.target_email,
              :html => render_to_string( :file => 'user_mailer/invitation', layout: nil ).to_str
          }
          mg_client.send_message "controversciences.org", message
        end
        count += 1
      end
    end
    @private_timeline = PrivateTimeline.new
    if count == 0
      @private_timeline.errors.add(:base, t('activerecord.attributes.edge.target'))
    else
      flash.now[:success] = t('controllers.slack_invit', email: current_user.email)
    end
    params[:timeline_id] = private_timeline_params[:timeline_id]
    set_index
    render 'index'
  end

  def set_index
    @private_timelines = PrivateTimeline.includes(:user).where(timeline_id: params[:timeline_id])
    @user_names = User.order(:name).where(activated: true).not( id: @private_timelines.map{ |u| u.user_id } ).pluck(:name, :id)
  end

  private

  def private_timeline_params
    params.require(:private_timeline).permit(:user_id, :timeline_id)
  end
end
