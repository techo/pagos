require 'spec_helper'

describe PaymentsController do
  describe "GET new" do
    it "should assign a payment instance to payment" do
      get :new
      assigns(:payment).should be_an_instance_of Payment
    end

    it "should assign the family id" do
      get :new, family_id: "1"
      assigns(:family_id).should == "1"
    end
  end

  describe "POST create" do
    it "should save a payment" do
      expect {
        post :create, payment: { family_id: 1, amount: 1, date: DateTime.now }
      }.to change{ Payment.count }.by(1)
    end

    it "should redirect to home on success" do
      post :create, payment: { family_id: 1, amount: 1, date: DateTime.now }
      response.should redirect_to root_path
    end

    it "should not redirect for invalid Payment" do
      post :create, payment: { family_id:1, amount: "" }
      response.should_not redirect_to root_path
    end
  end
end
