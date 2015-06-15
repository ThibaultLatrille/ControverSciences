class TyposController < ApplicationController
  before_action :logged_in_user, only: [:accept, :create, :destroy]

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
    end
    @typo.user_id = current_user.id
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

  def accept
    @typo = Typo.find( params[:id] )
    @typo.set_content(current_user.id)
    @typo.destroy
    redirect_to notifications_important_path
  end

  def destroy
    @typo = Typo.find( params[:id] ).destroy
    redirect_to notifications_important_path
  end

  private

  def get_params
    params.permit(:comment_id, :summary_id, :field)
  end

  def typo_params
    params.require(:typo).permit(:comment_id, :summary_id, :content, :field)
  end
end
