class ReportsController < ApplicationController
  before_action :verify_can_manage_payments

  def new
    @report = HistoricalPaymentsReport.new
    render :template => "reports/historical_payments_report"
  end

  def create
    @report = HistoricalPaymentsReport.new
    @report.from = Date.parse(create_params["from"])
    @report.to = Date.parse(create_params["to"])
    @report.generate
    unless @report.result.blank?
      respond_to do |format|
        format.html{ render :template => "reports/historical_payments_report" }
        format.csv { send_data @report.to_csv, :filename => "historical_payments_report_#{create_params['from']}_to_#{create_params['to']}.csv" }
      end
    else
      redirect_to new_report_path, flash: {error: "No hay registros para el intervalo seleccionado"}
    end
  end

  private
  def new_params
    params.require(:report_name)
  end

  def create_params
    params.require(:report).permit(:from, :to)
  end

  def verify_can_manage_payments
    redirect_to root_url unless current_user && current_user.can_manage_users?
  end
end
