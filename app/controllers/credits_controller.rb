class CreditsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    my_credit = Credit.find_by({user_id: current_user.id,
                            summary_id: credit_params[:summary_id]})
    if my_credit
      if credit_params[:value] == "0"
        my_credit.destroy_with_counters
        flash[:success] = "Le nombre de crédits accordés à cette synthèse a été modifié."
      else
        if my_credit.update( {value: credit_params[:value]})
          flash[:success] = "Le nombre de crédits accordés à cette synthèse a été modifié."
        else
          flash[:danger] = "Impossible d'effectuer cette action."
        end
      end
    elsif credit_params[:value] != "0"
      credit = Credit.new({user_id: current_user.id,
                       timeline_id: credit_params[:timeline_id],
                       summary_id: credit_params[:summary_id],
                       value: credit_params[:value]})
      if credit.save
        flash[:success] = "Le nombre de crédits accordés à cette synthèse a été modifié."
      else
        flash[:danger] = "Impossible d'effectuer cette action."
      end
    else
      flash[:danger] = "Impossible d'effectuer cette action."
    end
    redirect_to summaries_path( timeline_id: credit_params[:timeline_id] )
  end

  def destroy
    if params[:id]=='all'
      credits = Credit.where( user_id: current_user.id, timeline_id: params[:timeline_id])
      credits.each do |credit|
        credit.destroy_with_counters
      end
      redirect_to summaries_path( timeline_id: params[:timeline_id] )
    elsif params[:id]=='none'
      credit = Credit.find_by(summary_id: params[:summary_id], user_id: current_user.id )
      timeline_id = credit.timeline_id
      credit.destroy_with_counters
      redirect_to summaries_path( timeline_id: timeline_id )
    else
      credits = Credit.find(params[:id])
      if credits.user_id == current_user.id
        credits.destroy_with_counters
        redirect_to my_items_votes_path
      end
    end
  end

  private

  def credit_params
    params.require(:credit).permit(:timeline_id, :reference_id, :summary_id, :value)
  end
end
