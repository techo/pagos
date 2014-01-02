class AssignmentsController < ApplicationController
  before_action :verify_can_manage_users
  
  def new

  end

  def create
    geography = Geography.where(:village_id => 1).first_or_create
    geography.volunteers << current_user.becomes(Volunteer)
    
    respond_to do |format|
      format.json { render json: {:success => true} }
    end
  end

  def verify_can_manage_users
    redirect_to root_url unless current_user && current_user.can_manage_users?
  end
end
