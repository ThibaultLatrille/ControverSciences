class MeliorationsController < ApplicationController
  def new
    @comment = Comment.find(params[:comment_id])
    if @comment.user_id == current_user.id
      redirect_to edit_comment_path( @comment )
    end
    @melioration = Melioration.new(user_id: current_user.id, comment_id: @comment.id,
                   content: @comment.content,  to_user_id: @comment.user_id)
    @list = Reference.where( timeline_id: @comment.timeline_id ).pluck( :title, :id )
  end

  def create
    comment = Comment.find( melioration_params[:comment_id])
    if comment.user_id == current_user.id
      flash[:danger] = "Vous n'avez pas ces droits !"
      redirect_to root_url
    end
    @melioration = Melioration.new( user_id: current_user.id,
            comment_id: comment.id, to_user_id: comment.user_id,
            content: melioration_params[:content], message: melioration_params[:message] )
    if @melioration.save
      flash[:success] = "Amélioration envoyé"
      redirect_to reference_url( comment.reference_id )
    else
      render 'static_pages/home'
    end
  end

  def show
    @melioration = Melioration.find( params[:id] )
    if @melioration.to_user_id != current_user.id
      flash[:danger] = "Vous n'avez pas accés à cette page !"
      redirect_to root_url
    end
    @comment = Comment.find( @melioration.comment_id )
    if @melioration.pending
      @melioration.update_attributes( pending: false )
      User.decrement_counter( :pending_meliorations, current_user.id)
    end
    @comment_modif = Comment.new(user_id: current_user.id,
                                 created_at: @comment.created_at,
                                 votes_plus: @comment.votes_plus,
                                 votes_minus: @comment.votes_minus,
                          content: @melioration.content )
    @comment_modif.markdown(root_url)
    @diff = Diffy::Diff.new(@comment.content, @melioration.content, :include_plus_and_minus_in_html => true).to_s(:html)

  end

  def accept
    melioration = Melioration.find( params[:id] )
    if melioration.to_user_id != current_user.id
      flash[:danger] = "Vous n'avez pas cette autorisation"
      redirect_to root_url
    end
    if params[:accept] == "true"
      comment = Comment.find( melioration.comment_id )
      comment.content = melioration.content
      if comment.update_markdown( root_url, current_user.id )
        melioration.update_attributes(accepted: true)
        User.decrement_counter( :waiting_meliorations, melioration.to_user_id)
        flash[:success] = "Acceptée"
        redirect_to pending_meliorations_path
      else
        flash[:danger] = "Echec"
        redirect_to pending_meliorations_path
      end
    else
      melioration.update_attributes(accepted: false)
      User.decrement_counter( :waiting_meliorations, melioration.to_user_id)
      flash[:danger] = "Déclinée"
      redirect_to pending_meliorations_path
    end
  end

  def pending
    @meliorations = Melioration.where( to_user_id: current_user.id).order( pending: :desc).page(params[:page]).per(10)
  end

  def index
    @meliorations = Melioration.where( user_id: current_user.id).order( pending: :desc).page(params[:page]).per(10)
  end

  private

  def melioration_params
    params.require(:melioration).permit(:content, :message, :comment_id)
  end
end
