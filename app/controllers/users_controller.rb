class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def checkemail
    mydomain = params[:user].partition("@")[2]
    Domain.all.pluck(:name).each do |domain|
      if mydomain.include? domain
        render :nothing => true, :status => 200
        return true
      end
    end
    render :nothing => true, :status => 409
  end

  def index
    @users = User.includes(:user_detail).where(activated: true).order(score: :desc, created_at: :desc).page(params[:page]).per(24)
  end

  def show
    begin
      @user        = User.find(params[:id])
      @user_detail = @user.user_detail
      @timelines   = Timeline.includes(:tags).select(:id, :slug, :name).where(user_id: @user.id)
      @references  = Reference.select(:id, :slug, :timeline_id, :title).where(user_id: @user.id)
      @comments    = Comment.select(:id, :reference_id, :title_markdown).where(user_id: @user.id)
      @summaries   = Summary.select(:id, :timeline_id, :content).where(user_id: @user.id)
      unless logged_in? && current_user.id == @user.id
        @timelines   = @timelines.where.not(private: true)
        @comments    = @comments.where(public: true)
        @summaries   = @summaries.where(public: true)
      end
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = "Aucun contributeur à cette adresse ;-("
      redirect_to users_path
    end
  end

  def edit
    @user        = User.find(params[:id])
    @user_detail = UserDetail.find_by_user_id(params[:id])
    unless @user_detail
      @user_detail            = UserDetail.new(user_id: params[:id])
      @user_detail.send_email = true
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @favorite = Timeline.find_by(favorite: true, staging: false)
      if @user.invalid_email
        PendingUser.create(user_id: @user.id, why: user_params[:why])
        render 'users/invalid'
      else
        if Rails.env.production?
          mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
          message   = {
              :subject => t('controllers.activation_email'),
              :from    => "ControverSciences.org <activation@controversciences.org>",
              :to      => @user.email,
              :html    => render_to_string(:file => 'user_mailer/account_activation', layout: nil).to_str
          }
          mg_client.send_message "controversciences.org", message
        end
        render 'users/success'
      end
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = t('controllers.user_updated')
      redirect_to @user
    else
      @user_detail = UserDetail.find_by_user_id(params[:id])
      unless @user_detail
        @user_detail            = UserDetail.new(user_id: params[:id])
        @user_detail.send_email = true
      end
      render 'edit'
    end
  end

  def switch_admin
    if current_user.can_switch_admin
      if current_user.admin
        current_user.update_columns(admin: false)
      else
        current_user.update_columns(admin: true)
      end
    end
    redirect_to :back
  end

  def slack
    if Rails.env.production?
      Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end
      client = Slack::Web::Client.new

      if client.auth_test
        if client.users_list["members"].index { |user| user["profile"]["email"] == current_user.email }.blank?
          if ["ens-lyon.fr", "umontpellier.fr", "etu.umontpellier.fr", "etud.univ-montp2.fr", "univ-montp2.fr", "controversciences.org"].include? current_user.email.partition("@")[2]
            redirect_to "https://controversciences.slack.com/signup"
          else
            begin
              client.post('users.admin.invite', {email: current_user.email, set_active: true})
              flash[:success] = t('controllers.slack_invit', email: current_user.email)
              redirect_to :back
            rescue
              admin_group = client.groups_list['groups'].detect { |c| c['name'] == 'admins' }
              client.chat_postMessage(channel: admin_group['id'], text: "#{current_user.email} invitation needs to be resent !")
              flash[:danger] = t('controllers.slack_already_invited', email: current_user.email)
              redirect_to :back
            end
          end
        else
          redirect_to "https://controversciences.slack.com/signin"
        end
      else
        flash[:danger] = t('controllers.slack_connexion_lost')
        redirect_to :back
      end
    else
      redirect_to "https://controversciences.slack.com/signup"
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('controllers.user_deleted')
    redirect_to users_url
  end

  def previous
    users = User.select(:id, :slug, :score).order(score: :desc).where(activated: true)
    i     = users.index { |x| x.id == params[:id].to_i }
    i     ||= users.sample
    if i == 0
      i = users.length-1
    else
      i-=1
    end
    redirect_to user_path(users[i])
  end

  def next
    users = User.select(:id, :slug, :score).order(score: :desc).where(activated: true)
    i     = users.index { |x| x.id == params[:id].to_i }
    i     ||= users.sample
    if i == users.length-1
      i = 0
    else
      i += 1
    end
    redirect_to user_path(users[i])
  end

  def network
    @nodes = User.where(activated: true).select(:id, :slug, :name,  :score)
    user_ids = @nodes.map{ |u| u.id }
    ids = []
    @nodes.each do |user|
      ids += user_ids.sample(rand(user.score+2)).reject{ |u| u == user.id }.map{ |u| [u, user.id] }
    end
    @links = ids.uniq{ |e| [e[0],e[1]].sort }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :first_name, :last_name,
                                 :password_confirmation, :why, :terms_of_service)
  end

  def user_detail_params
    params.require(:user_detail).permit(:user_id, :biography, :picture)
  end
end
