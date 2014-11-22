class VotesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :destroy]

  def new
    @comment = Comment.find(vote_params[:comment_id])
    @best_comment = BestComment.find_by(reference_id: vote_params[:reference_id]).comment
    if @comment.user_id == current_user.id
      flash[:danger] = "Vous croyez vraiment qu'on aller vous laissez voter
pour votre propre analyse"
      redirect_to reference_path(@comment.reference_id)
    elsif @best_comment.id == @comment.id
      flash[:danger] = "Cette analyse est la plus coté, il faut voter pour
les autres analyses relativement à celle-ci"
      redirect_to reference_path(@comment.reference_id)
    else
      @my_vote = Vote.find_by({user_id: current_user.id,
                                comment_id: vote_params[:comment_id]})
      if @my_vote
        if @my_vote.value.to_s == vote_params[:value]
          flash[:danger] = "Vous aviez déjà voté de cette façon auparavant"
        redirect_to reference_path(@comment.reference_id)
        end
      end
      @vote = Vote.new()
    end
  end

  def create
    if params[:update]
      my_vote = Vote.find_by({user_id: current_user.id,
                            comment_id: vote_params[:comment_id]})
      if my_vote.update( {value: vote_params[:value]})
        flash[:success] = "Vote enregistré"
        redirect_to controller: 'references', action: 'show',
                    id: vote_params[:reference_id]
      else
        render 'static_pages/home'
      end
    else
      vote = Vote.new({user_id: current_user.id,
                      reference_id: vote_params[:reference_id],
                      timeline_id: vote_params[:timeline_id],
                     comment_id: vote_params[:comment_id],
                     value: vote_params[:value]})
        if vote.save
          flash[:success] = "Vote enregistré"
          redirect_to controller: 'references', action: 'show',
                      id: vote_params[:reference_id]
        else
          render 'static_pages/home'
        end
    end
  end

  def destroy
  end

  private

  def vote_params
    params.require(:vote).permit(:timeline_id, :reference_id, :comment_id, :value)
  end
end
