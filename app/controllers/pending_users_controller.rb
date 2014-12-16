class PendingUsersController < ApplicationController
  before_action :admin_user, only: [:destroy]

  def destroy
    pending = PendingUser.find_by( user_id: params[:user_id])
    @user = User.find( params[:user_id] )
    if params[:handle] == "destroy"
      @user.destroy
    elsif params[:handle] == "accept_domain" || params[:handle] == "accept"
      if params[:handle] == "accept_domain"
        Domain.create( name: @user.email.partition("@")[2] )
      end
      @user.create_activation_digest
      @user.update_columns( activation_digest: @user.activation_digest )
      @user.send_activation_email
    end
    pending.destroy
    redirect_to assistant_index_path
  end

end
