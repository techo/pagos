class HomeController < ApplicationController

  def index
    if current_user
      if current_user.can_manage_users?
        redirect_to users_path
      elsif current_user.can_manage_payments?
        redirect_to payments_path
      end
    end
  end

end
