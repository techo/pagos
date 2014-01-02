require 'spec_helper'

describe GeographiesController do

  describe "before filter" do
    it "redirects to root url if the current user cannot manage users" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:volunteer_user)

      get :index
      response.should redirect_to root_url
    end

    it "redirects if there is no current user" do
      get :index
      response.should redirect_to root_url
    end

    it "does not redirect to root url if the current user can manage users" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)

      get :index
      response.should_not be_redirect
    end
  end

  describe "GET index" do
    it "should return geographies from the Pilote API in json format" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)

      pilote_response = {idAsentamiento:"1"}
      PiloteHelper.stub(:get_geographies).and_return(pilote_response)

      get :index
      PiloteHelper.get_geographies
      response.body.should == {idAsentamiento:"1"}.to_json
    end
  end
end
