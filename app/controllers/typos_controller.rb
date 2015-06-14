class TyposController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def new
    @typo = Type.new( typo_params )
    if !@typo.comment_id.blank?
      com = Comment.find(typo_params[:comment_id])
      @typo.content = com.field_content(typo_params[:field])
      @typo.target_user_id = com.user_id
    elsif !@typo.summary_id.blank?
      sum = Summary.select( :user_id, :content ).find(typo_params[:summary_id])
      @typo.content = sum.content
      @typo.target_user_id = sum.user_id
    end
    @typo.user_id = current_user.id
    respond_to do |format|
      format.js { render 'typos/new', :content_type => 'text/javascript', :layout => false}
    end
  end

  def create
    @typo = Type.new( typo_params )
    if !@typo.comment_id.blank?
      @typo.target_user_id = Comment.select( :user_id ).find(typo_params[:comment_id]).user_id
    elsif !@typo.summary_id.blank?
      @typo.target_user_id = Summary.select( :user_id ).find(typo_params[:summary_id]).user_id
    end
    @typo.user_id = current_user.id
    if type.save
      respond_to do |format|
        format.js { render 'typos/success', :content_type => 'text/javascript', :layout => false}
      end
    else
      respond_to do |format|
        format.js { render 'typos/fail', :content_type => 'text/javascript', :layout => false}
      end
    end
  end

  private

  def typo_params
    params.require(:typo).permit(:comment_id, :summary_id, :content, :field)
  end
end
