class UsersController < ApplicationController

  def edit
    @users = User.all
  end

  def update
    User.update(params[:user].keys, update_role_params.values)
    redirect_to action: 'edit'
  end

  private
  def update_role_params
    params.permit(user: [:role]).values.first
  end
end
