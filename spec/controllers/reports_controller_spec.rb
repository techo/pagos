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
      pending("completar la prueba")
      #post :create, report: {report_name:"HistoricalPaymentsReport", from:Date.today-10, to:Date.today}
      #assigns(:report).should_receive(:generate)
    end

    it "should render view according to repord name" do
      post :create, report: {report_name:"HistoricalPaymentsReport", from:Date.today-10, to:Date.today}
      response.should render_template("reports/historical_payments_report")
    end
  end

end
