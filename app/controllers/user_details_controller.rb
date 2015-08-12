class UserDetailsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    user_id = current_user.id
    @user_detail = UserDetail.find_by_user_id( user_id )
    if @user_detail
      @user_detail.update(user_detail_params)
      if user_detail_params[:delete_picture] == 'true'
        @user_detail.figure_id = nil
      elsif user_detail_params[:has_picture] == 'true'
        @user_detail.figure_id = Figure.order( :created_at ).where( user_id: current_user.id,
                                                                profil: true ).last.id
      end
    else
      @user_detail = UserDetail.new(user_detail_params)
      @user_detail.user_id = user_id
      if user_detail_params[:has_picture] == 'true' && user_detail_params[:delete_picture] == 'false'
        @user_detail.figure_id = Figure.order( :created_at ).where( user_id: current_user.id,
                                                                    profil: true ).last.id
      end
    end
    if @user_detail.save
      flash[:info] = "Modification de profil enregistrée."
      redirect_to user_path(id: user_id )
    else
      @user = User.find( user_id )
      @timelines = Timeline.select(:id, :slug, :name).where(user_id: user_id )
      @references = Reference.select(:id, :slug, :timeline_id, :title).where(user_id: user_id )
      @user_detail = user_detail.select(:id, :reference_id, :title_markdown ).where(user_id: user_id )
      @summaries = Summary.select(:id, :timeline_id, :content ).where(user_id: user_id )
      render 'users/edit'
    end
  end

  private

  def user_detail_params
    params.require(:user_detail).permit( :job, :institution, :website, :biography, :has_picture, :delete_picture, :send_email)
  end
end
