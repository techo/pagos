class AssignmentsController < ApplicationController
  before_action :verify_can_manage_users

  def new

  end

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
    respond_to do |format|
      format.json { render json: {:success => success,  :errors => success ? nil : "error"}}
    end
  end

  def show
    village_id = params[:id]
    @geography = Geography.where(:village_id => village_id).first
    if ( @geography  )
      volunteerIds = @geography.volunteers.map{|volunteer| volunteer.id}
      render :json => volunteerIds.to_json
    else
      render :json => [].to_json
    end
  end

  def destroy
    geography = Geography.where(:village_id => params[:id]).first
    Assignment.destroy_all(:geography_id => geography.id, :volunteer_id => params[:volunteer_id])
    head :ok
  end

  def verify_can_manage_users
    redirect_to root_url unless current_user && current_user.can_manage_users?
  end

  private
  def assignments_params
    params.require("data").permit("village_id", "volunteer_id")
  end
end
