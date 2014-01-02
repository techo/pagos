require 'spec_helper'

describe AssignmentsController do
  describe "before filter" do
    it "redirects to root url if the current user cannot manage users" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:volunteer_user)

      get :new
      response.should redirect_to root_url
    end

    it "redirects if there is no current user" do
      get :new
      response.should redirect_to root_url
    end

    it "does not redirect to root url if the current user can manage users" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)

      get :new
      response.should_not be_redirect
    end
  end

  describe "POST create" do
    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)
    end

    it "should return a json with a success message" do
      post :create,  :format => :json
      JSON.parse(response.body)["success"].should == true
    end
  end
end
