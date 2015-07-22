class ReferenceUserTagsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    ref_user_tag = ReferenceUserTag.find_or_create_by( reference_id: reference_user_tag_params[:reference_id],
                                                 user_id: current_user.id,
                                                 timeline_id: reference_user_tag_params[:timeline_id])
    if ref_user_tag.set_tag_list(params[:reference_user_tag][:tag_list].blank? ? [] : params[:reference_user_tag][:tag_list])
      ref_user_tag.update_tags
      flash[:success] = "Votre avis a été enregistré."
      redirect_to reference_path(reference_user_tag_params[:reference_id])
    else
      flash[:danger] = "Votre avis n'a pas pu être enregistré."
      redirect_to reference_path(reference_user_tag_params[:reference_id])
    end
  end

  private

  def reference_user_tag_params
    params.require(:reference_user_tag).permit(:timeline_id, :reference_id )
  end
end
