class ReportsController < ApplicationController
  before_action :verify_can_manage_payments

  def new
    r = new_params.constantize
    @report = r.new
    render :template => "reports/#{new_params.underscore}"
  end

  def create
    r = create_params["report_name"].constantize
    @report = r.new
    @report.from = create_params["from"]
    @report.to = create_params["to"]
    @report.generate
    render :template => "reports/#{create_params["report_name"].underscore}"
  end

  private
  def new_params
    params.require(:report_name)
  end

  def create_params
    params.require(:report).permit(:report_name, :from, :to)
  end

  def verify_can_manage_payments
    redirect_to root_url unless current_user && current_user.can_manage_users?
  end
end
