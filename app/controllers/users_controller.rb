class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.order(:created_at).page(params[:page]).per(20)
  end

  def show
    @user = User.find(params[:id])
    @user_detail = UserDetail.find_by_user_id( params[:id] )
    @timelines = Timeline.select(:id, :name).where(user_id: params[:id])
    @references = Reference.select(:id, :timeline_id, :title_fr).where(user_id: params[:id])
    @comments = Comment.select(:id, :reference_id, :f_1_content ).where(user_id: params[:id])
    @summaries = Summary.select(:id, :timeline_id, :content ).where(user_id: params[:id])
  end

  def edit
    @user = User.find(params[:id])
    @user_detail = UserDetail.find_by_user_id( params[:id] )
    unless @user_detail
      @user_detail = UserDetail.new( user_id: params[:id] )
    end
    @timelines = Timeline.select(:id, :name).where(user_id: params[:id])
    @references = Reference.select(:id, :timeline_id, :title_fr).where(user_id: params[:id])
    @comments = Comment.select(:id, :reference_id, :f_1_content ).where(user_id: params[:id])
    @summaries = Summary.select(:id, :timeline_id, :content ).where(user_id: params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if @user.invalid_email
        PendingUser.create( user_id: @user.id, why: user_params[:why])
        message = "Votre incription est en cours de traitement"
        flash[:info] = message
        redirect_to root_url
      else
        @user.send_activation_email
        message = "Le lien pour activer le compte doit être parvenu à votre boîte mail, "
        message += "à moins qu'il se soit noyé dans vos spams ou perdu dans les méandres d'internet."
        flash[:info] = message
        redirect_to root_url
      end
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profil modifié"
      redirect_to @user
    else
      @user_detail = UserDetail.find_by_user_id( params[:id] )
      unless @user_detail
        @user_detail = UserDetail.new( user_id: params[:id] )
      end
      @timelines = Timeline.select(:id, :name).where(user_id: params[:id])
      @references = Reference.select(:id, :timeline_id, :title_fr).where(user_id: params[:id])
      @comments = Comment.select(:id, :reference_id, :f_1_content ).where(user_id: params[:id])
      @summaries = Summary.select(:id, :timeline_id, :content ).where(user_id: params[:id])
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Utilisateur détruit"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :why)
  end

  def user_detail_params
    params.require(:user_detail).permit(:user_id, :biography, :picture)
  end
end
