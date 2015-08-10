class TyposController < ApplicationController
  before_action :logged_in_user, only: [:accept, :create, :destroy, :index]
  before_action :admin_user, only: [:index]

  def new
    @typo = Typo.new( get_params )
    if !@typo.comment_id.blank?
      com = Comment.find(get_params[:comment_id])
      @typo.content = com.field_content(get_params[:field].to_i)
      @typo.target_user_id = com.user_id
    elsif !@typo.summary_id.blank?
      sum = Summary.select( :user_id, :content ).find(get_params[:summary_id])
      @typo.content = sum.content
      @typo.target_user_id = sum.user_id
    elsif !@typo.frame_id.blank?
      fra = Frame.find(get_params[:frame_id])
      if get_params[:field].to_i == 0
          @typo.content = fra.name
      else
          @typo.content = fra.content
      end
      @typo.target_user_id = fra.user_id
    end
    @typo.user_id = current_user.id
    respond_to do |format|
      format.js { render 'typos/new', :content_type => 'text/javascript', :layout => false}
    end
  end

  def create
    @typo = Typo.new( typo_params )
    if !@typo.comment_id.blank?
      @typo.target_user_id = Comment.select( :user_id ).find(typo_params[:comment_id]).user_id
    elsif !@typo.summary_id.blank?
      @typo.target_user_id = Summary.select( :user_id ).find(typo_params[:summary_id]).user_id
    elsif !@typo.frame_id.blank?
      @typo.target_user_id = Frame.select( :user_id ).find(typo_params[:frame_id]).user_id
    end
    @typo.user_id = current_user.id
    if @typo.target_user_id == @typo.user_id || current_user.admin
      if @typo.set_content(current_user.id, current_user.admin)
        respond_to do |format|
          format.js { render 'typos/mine', :content_type => 'text/javascript', :layout => false}
        end
      else
        respond_to do |format|
          format.js { render 'typos/fail', :content_type => 'text/javascript', :layout => false}
        end
      end
    else
      if @typo.save
        respond_to do |format|
          format.js { render 'typos/success', :content_type => 'text/javascript', :layout => false}
        end
      else
        respond_to do |format|
          format.js { render 'typos/fail', :content_type => 'text/javascript', :layout => false}
        end
      end
    end
  end

  def index
    @typos = Typo.all
  end

  def accept
    @typo = Typo.find( params[:id] )
    @typo.set_content(current_user.id, current_user.admin)
    if @typo.target_user_id == current_user.id || current_user.admin
      @typo.destroy
      User.increment_counter(:my_typos, @typo.user_id)
      User.increment_counter(:target_typos, @typo.target_user_id)
    end
    if current_user.admin
      redirect_to typos_path
    else
      redirect_to notifications_important_path
    end
  end

  def destroy
    @typo = Typo.find( params[:id] )
    if @typo.target_user_id == current_user.id || current_user.admin
      @typo.destroy
    end
    if current_user.admin
      redirect_to typos_path
    else
      redirect_to notifications_important_path
    end
  end

  private

  def get_params
    params.permit(:comment_id, :summary_id, :field, :frame_id)
  end

  def typo_params
    params.require(:typo).permit(:comment_id, :summary_id, :frame_id, :content, :field)
  end
end
