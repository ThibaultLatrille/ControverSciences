class VotesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    my_vote = Vote.find_by({user_id: current_user.id,
                            comment_id: vote_params[:comment_id]})
    if my_vote
      if vote_params[:value] == "0"
        my_vote.destroy_with_counters
        flash[:success] = "Vote nul prit en compte"
        render 'static_pages/home'
      else
        if my_vote.update( {value: vote_params[:value]})
          flash[:success] = "Vote mis à jour"
          redirect_to controller: 'references', action: 'show',
                      id: vote_params[:reference_id]
        else
          flash[:danger] = "Erreur"
          render 'static_pages/home'
        end
      end
    elsif vote_params[:value] != "0"
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
          flash[:danger] = "Erreur"
          render 'static_pages/home'
        end
    else
      flash[:danger] = "Vote nul non prit en compte"
      render 'static_pages/home'
    end
  end

  def destroy
    if params[:id]=='all'
      votes = Vote.where( user_id: current_user.id, reference_id: params[:reference_id])
      votes.each do |vote|
        vote.destroy_with_counters
      end
      redirect_to reference_path( params[:reference_id] )
    elsif params[:id]=='none'
      vote = Vote.find_by(comment_id: params[:comment_id], user_id: current_user.id )
      reference_id = vote.reference_id
      vote.destroy_with_counters
      redirect_to reference_path( reference_id )
    else
      votes = Vote.find(params[:id])
      if votes.user_id == current_user.id
        votes.destroy_with_counters
        redirect_to my_items_votes_path
      end
    end
  end

  private

  def vote_params
    params.require(:vote).permit(:timeline_id, :reference_id, :comment_id, :value)
  end
end
