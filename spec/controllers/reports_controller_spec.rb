require 'spec_helper'

describe ReportsController do
  after (:all) do
    User.destroy_all
  end

  describe "before filter" do
    it "should redirect to root page if user can not manage payments" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:volunteer_user)

      get :new
      response.should redirect_to root_url
    end
  end

  describe "GET new" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)
    end

    it "should raise ParameterMissing exception" do
      expect {
        get :new
      }.to raise_error ActionController::ParameterMissing
    end

    it "should assign report an instance of requested report" do
      get :new, report_name: "HistoricalPaymentsReport"
      assigns(:report).should be_instance_of HistoricalPaymentsReport
    end

    it "should render view according to repord name" do
      get :new, report_name: "HistoricalPaymentsReport"
      response.should render_template("reports/historical_payments_report")
    end
  end

  describe "POST create" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)
    end

    it "should generate the current report" do
      report = HistoricalPaymentsReport.new
      HistoricalPaymentsReport.any_instance.should_receive(:generate).and_return(report)
      post :create, report: {report_name:"HistoricalPaymentsReport", from:Date.today-10, to:Date.today}
      flash[:error].should == "No hay registros para el intervalo seleccionado"
      response.should redirect_to new_report_url(report_name: "HistoricalPaymentsReport")
    end

    it "should render view according to report name" do
      volunteer = FactoryGirl.create(:volunteer_user)
      FactoryGirl.create(:payment, date: Date.parse("2014-01-03"), volunteer_id: volunteer.id, family_id: 1)
      families_details = [{"id_de_familia"=>"1","jefe_de_familia"=>"Teresa","monto_original"=>"200.00","asentamiento"=>"Collana", "ciudad" => "Montecristi", "provincia" => "Manabi","pagos"=>"60.00"}]
      PiloteHelper.should_receive(:get_families_details).with([1]).and_return(families_details)

      post :create, report: {report_name:"HistoricalPaymentsReport", from:"2014-01-02", to:"2014-01-20"}
      response.should_not redirect_to new_report_url
      response.should render_template("reports/historical_payments_report")
    end
  end

  describe "Export to CSV" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)
      volunteer = FactoryGirl.create(:volunteer_user)
      FactoryGirl.create(:payment, date: Date.parse("2014-01-02"), volunteer_id: volunteer.id, family_id: 1, amount:20, debt:120)
      FactoryGirl.create(:payment, date: Date.parse("2014-01-02"), volunteer_id: volunteer.id, family_id: 2, amount:15, debt:105)
      families_details = [{"id_de_familia"=>"1","jefe_de_familia"=>"Teresa","monto_original"=>"200.00","asentamiento"=>"Collana", "ciudad" => "Montecristi", "provincia" => "Manabi","pagos"=>"60.00"},
                          {"id_de_familia"=>"2","jefe_de_familia"=>"Ramon","monto_original"=>"180.00","asentamiento"=>"Cotocollao", "ciudad" => "Montecristi", "provincia" => "Manabi","pagos"=>"60.00"}]
      PiloteHelper.stub(:get_families_details).with([1, 2]).and_return(families_details)
    end

    it "should render data in csv format" do
      post :create, format: :csv, report: {report_name:"HistoricalPaymentsReport", from:"2014-01-01", to:"2014-01-11"}
      response.should_not render_template("reports/historical_payments_report")
      response.headers['Content-Disposition'].should == 'attachment; filename="historical_payments_report_2014-01-01_to_2014-01-11.csv"'
      response.headers['Content-Type'].should == "text/csv"
      response.body.should == "Comunidad,Familia,Fecha,Saldo Inicial,Abono,Saldo Final,Efectivo o Comprobante,Registrado por\nManabi - Montecristi - Collana,Teresa,2014-01-02 00:00:00 UTC,140.0,20.0,120,EFECTIVO,SuzyV V\nManabi - Montecristi - Cotocollao,Ramon,2014-01-02 00:00:00 UTC,120.0,15.0,105,EFECTIVO,SuzyV V\n"
    end
  end

end
