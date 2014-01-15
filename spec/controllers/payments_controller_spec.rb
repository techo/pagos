require 'spec_helper'

describe PaymentsController do
  describe "before filter" do
    it "should redirect to root page if user can not manage payments" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)

      get :index
      response.should redirect_to root_url
    end

    it "should redirect to root page if user is not authenticated" do
      post :create
      response.should redirect_to root_url
    end

    it "should not redirect to root page if user is a volunteer" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:volunteer_user)

      get :index
      response.should_not redirect_to root_url
    end
  end

  describe "GET index" do
    it "should assign the families from the Pilote API" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      volunteer_user = FactoryGirl.create(:volunteer_user)
      sign_in volunteer_user

      pilote_response = { id_familia: "1", jefe_de_hogar: "Juan" }
      PiloteHelper.stub(:get_families).with([volunteer_user]).and_return(pilote_response)
      get :index
      assigns(:families).should == pilote_response
    end
  end

  describe "POST create" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:volunteer_user)
      sign_in @user
    end

    it "should save a payment" do
      expect {
        post :create, payment: { family_id: 1, amount: 1, date: DateTime.now }
      }.to change{ Payment.count }.by(1)
    end

    it "should add a payment to volunteer" do
      expect {
        post :create, payment: { family_id: 1, amount: 1, date: DateTime.now }
      }.to change {@user.becomes(Volunteer).payments.count }.by(1)
    end

    it "should redirect to payments on success" do
      post :create, payment: { family_id: 1, amount: 1, date: DateTime.now }
      response.should redirect_to payments_path
    end

    it "should assign a payment with passed parameters" do
        post :create, payment: { family_id: 1, amount: 1, deposit_number: "1234", date: Date.today }
        assigns(:payment).family_id.should == 1
        assigns(:payment).amount.should == 1
        assigns(:payment).deposit_number.should == "1234"
        assigns(:payment).date.should == Date.today
    end

    it "displays a flash message on success" do
      post :create, payment: { family_id: 1, amount: 1, date: DateTime.now }
      flash[:success].should == "El pago ha sido registrado!"
    end

    it "re-renders the index action for invalid Payment" do
      post :create, payment: { family_id:1, amount: "" }
      response.should render_template("index")
    end

    it "assigns payment if Payment is invalid" do
      post :create, payment: { family_id:1, amount: "" }
      assigns(:payment).should_not be_nil
    end
  end
end
