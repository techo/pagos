class AssignmentsController < ApplicationController
  before_action :verify_can_manage_users

  def create
    if ( params["data"].nil? || params["data"]["volunteer_id"].nil? )
      success = false
    else
      volunteer_id = params["data"]["volunteer_id"]
      village_id = params["data"]["village_id"]
      @volunteer = Volunteer.find(volunteer_id)
      @geography = Geography.where(:village_id => village_id).first_or_create
      @geography.volunteers << @volunteer.becomes(Volunteer)
      success = true
    end
    render json: {:success => success,  :errors => success ? nil : "error"}
  end

  def show
    village_id = params[:id]
    @geography = Geography.where(:village_id => village_id).first
    if ( @geography  )
      render :json => Assignment.where(:geography_id => @geography.id).to_json
    else
      render :json => [].to_json
    end
  end

  def destroy
    Assignment.destroy(params[:id])
    head :ok
  end

  def verify_can_manage_users
    redirect_to root_url unless current_user && current_user.can_manage_users?
  end

end
