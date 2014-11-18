class AssistantController < ApplicationController
  def view
    unless current_user.admin?
      redirect_to root_url
    end
  end

  def users
    if current_user.admin?
      # do stuff
      end
    else
      redirect_to root_url
    end
  end

  def timelines
    if current_user.admin?
      # do stuff
    else
      redirect_to root_url
    end
  end

  def comments
    if current_user.admin?
      # do stuff
    else
      redirect_to root_url
    end
  end

end