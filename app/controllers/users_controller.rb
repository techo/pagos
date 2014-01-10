class UsersController < ApplicationController
  before_action :verify_can_manage_users

  def edit
    @users = User.all
  end

  def volunteers
    render :json => Volunteer.all
  end

  def update
    User.update(params[:user].keys, update_role_params.values)
    redirect_to users_path, flash: { success: "Los roles han sido grabados correctamente." }
  end

  private
  def update_role_params
    params.permit(user: [:role]).values.first
  end

  def verify_can_manage_users
    redirect_to root_url unless current_user && current_user.can_manage_users?
  end
end
