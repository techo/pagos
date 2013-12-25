require 'spec_helper'

describe GeographiesController do
  describe "GET index" do
    it "should assign the geographies from the Pilote API" do
      pilote_response = {idAsentamiento:"1"}
      PiloteHelper.stub(:get_geographies).and_return(pilote_response)

      get :index
      assigns(:geographies).should == pilote_response
    end
  end
end
