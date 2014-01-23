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
    @report.from = Date.parse(create_params["from"])
    @report.to = Date.parse(create_params["to"])
    @report.generate
    respond_to do |format|
      format.html{ render :template => "reports/#{create_params["report_name"].underscore}" }
      format.csv { send_data @report.to_csv, :filename => "#{create_params["report_name"].underscore}_#{create_params['from']}_to_#{create_params['to']}.csv" }
    end
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
