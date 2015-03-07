class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

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
    @users = User.order(score: :desc ).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @user_detail = UserDetail.find_by_user_id( params[:id] )
    @timelines = Timeline.select(:id, :name).where(user_id: params[:id])
    @references = Reference.select(:id, :timeline_id, :title).where(user_id: params[:id])
    @comments = Comment.select(:id, :reference_id, :title_markdown ).where(user_id: params[:id])
    @summaries = Summary.select(:id, :timeline_id, :content ).where(user_id: params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @user_detail = UserDetail.find_by_user_id( params[:id] )
    unless @user_detail
      @user_detail = UserDetail.new( user_id: params[:id] )
    end
    @timelines = Timeline.select(:id, :name).where(user_id: params[:id])
    @references = Reference.select(:id, :timeline_id, :title).where(user_id: params[:id])
    @comments = Comment.select(:id, :reference_id, :title_markdown ).where(user_id: params[:id])
    @summaries = Summary.select(:id, :timeline_id, :content ).where(user_id: params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @timelines = Timeline.order(:score => :desc).first(8)
      if @user.invalid_email
        PendingUser.create( user_id: @user.id, why: user_params[:why])
        render 'users/invalid'
      else
        mg_client = Mailgun::Client.new ENV['MAILGUN_CS_API']
        message = {
            :subject=> "Activation du compte sur ControverSciences",
            :from=>"activation@controversciences.org",
            :to => @user.email,
            :html => render_to_string( :file => 'user_mailer/account_activation', layout: nil ).to_str
        }
        mg_client.send_message "controversciences.org", message
        render 'users/success'
      end
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Modification de profil enregistrée."
      redirect_to @user
    else
      @user_detail = UserDetail.find_by_user_id( params[:id] )
      unless @user_detail
        @user_detail = UserDetail.new( user_id: params[:id] )
      end
      @timelines = Timeline.select(:id, :name).where(user_id: params[:id])
      @references = Reference.select(:id, :timeline_id, :title).where(user_id: params[:id])
      @comments = Comment.select(:id, :reference_id, :title_markdown ).where(user_id: params[:id])
      @summaries = Summary.select(:id, :timeline_id, :content ).where(user_id: params[:id])
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utilisateur destroyed"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :why, :terms_of_service)
  end

  def user_detail_params
    params.require(:user_detail).permit(:user_id, :biography, :picture)
  end
end
