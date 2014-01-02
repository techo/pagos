class AssignmentsController < ApplicationController
  before_action :verify_can_manage_users
  
  def new

  end

  def verify_can_manage_users
    redirect_to root_url unless current_user && current_user.can_manage_users?
  end
end
