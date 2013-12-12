class HomeController < ApplicationController

  def index
    if current_user && current_user.can_manage_users?
      redirect_to users_path
    end
  end

end
