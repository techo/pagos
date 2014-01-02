class GeographiesController < ApplicationController
  before_action :verify_can_manage_users

  def index
    render :json => PiloteHelper.get_geographies
  end

  def verify_can_manage_users
    redirect_to root_url unless current_user && current_user.can_manage_users?
  end
end
