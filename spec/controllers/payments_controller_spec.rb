require 'spec_helper'

describe PaymentsController do
  describe "GET index" do
    it "should assign the families from the Pilote API" do
      pilote_response = { id_familia: "1", jefe_de_hogar: "Juan" }
      PiloteHelper.stub(:get_families).and_return(pilote_response)
      get :index
      assigns(:families).should == pilote_response
    end
  end

  describe "POST create" do
    it "should save a payment" do
      expect {
        post :create, payment: { family_id: 1, amount: 1, date: DateTime.now }
      }.to change{ Payment.count }.by(1)
    end

    it "should redirect to payments on success" do
      post :create, payment: { family_id: 1, amount: 1, date: DateTime.now }
      response.should redirect_to payments_path
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
