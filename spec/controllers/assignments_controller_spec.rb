require 'spec_helper'

describe AssignmentsController do

  after (:all) do
    User.destroy_all
  end

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

  describe "GET show" do
    let!(:geography) { FactoryGirl.build(:geography, village_id: 1234) }
    let!(:volunteer_user) { FactoryGirl.build(:volunteer_user, id: 1) }

    before (:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in FactoryGirl.create(:administrator_user)

        @join = double(ActiveRecord::Relation)
        @join.stub(:first).and_return(geography)
        Geography.stub(:where).with(:village_id => geography.village_id.to_s).and_return(@join)
    end

    it "should assign a geography by village id" do
      get :show, :format => :json, id: geography.village_id
      assigns(:geography).should eq(geography)
    end

    it "should return all ids of volunteers for a geography" do
      Geography.any_instance.should_receive(:volunteers).and_return([volunteer_user])
      get :show, :format => :json, id: geography.village_id

      response.body.should == [volunteer_user.id].to_json
    end

    it "should return empty json if geography is not registered" do
      @join.stub(:first).and_return(nil)
      Geography.any_instance.should_not_receive(:volunteers).and_return([volunteer_user])
      get :show, :format => :json, id: geography.village_id

      response.body.should == [].to_json
    end
  end

  describe "POST create" do

    describe "valid parameters" do
      before (:each) do

        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in FactoryGirl.create(:administrator_user)
        @join = double(ActiveRecord::Relation)

        @volunteer_user = FactoryGirl.create(:volunteer_user, id: 1)
        @geography = FactoryGirl.create(:geography, village_id: 1234)
        @join.stub(:first_or_create).and_return(@geography)
        Volunteer.should_receive(:find).with(@volunteer_user.id).and_return(@volunteer_user)
        Geography.stub(:where).with(:village_id => @geography.village_id).and_return(@join)
      end


      it "should assign a volunteer with the volunteer_id" do
        post :create,  :format => :json, :data => { "village_id" => @geography.village_id, "volunteer_id" => @volunteer_user.id }
        assigns(:volunteer).should eq(@volunteer_user)
      end

      it "should assign a geography with the village_id" do
        post :create,  :format => :json, :data => { "village_id" => @geography.village_id, "volunteer_id" => @volunteer_user.id }
        assigns(:geography).should eq(@geography)
      end

      it "should return a json with a success message" do
        post :create,  :format => :json, :data => { "village_id" => @geography.village_id, "volunteer_id" => @volunteer_user.id }
        JSON.parse(response.body)["success"].should == true
      end

      it "should assign a volunteer to a geography according to the parameters" do
        expect {
          post :create, :format => :json, :data => { "village_id" => @geography.village_id, "volunteer_id" => @volunteer_user.id }
        }.to change{Assignment.count}.by(1)
      end
    end

    describe "invalid parameters" do
      before (:each) do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in FactoryGirl.create(:administrator_user)
        Volunteer.should_receive(:find).with(volunteer_user.id).and_return(volunteer_user)

        it "should return a json with a error message" do
          post :create,  :format => :json
          JSON.parse(response.body)["success"].should == false
        end

        it "should assign a volunteer with the volunteer_id" do
          post :create,  :format => :json
          Volunteer.should_not_receive(:find).with(any)
          Geography.should_not_receive(:find).with(any)
          assigns(:volunteer).should_not eq(volunteer_user)
        end
      end
    end
  end

  describe "DELETE destroy" do

    before (:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)
      @join = double(ActiveRecord::Relation)

      @volunteer_user = FactoryGirl.create(:volunteer_user)
      @geography = FactoryGirl.create(:geography, village_id: 1234)
      @join.stub(:first_or_create).and_return(@geography)
      # Volunteer.should_receive(:find).with(@volunteer_user.id).and_return(@volunteer_user)
      # Geography.stub(:where).with(:village_id => @geography.village_id).and_return(@join)
    end

    it "should detach a volunteer from a geography" do
      post :create,  :format => :json, :data => { "village_id" => @geography.village_id, "volunteer_id" => @volunteer_user.id }
      @geography.reload
      @geography.volunteers.should include(@volunteer_user)

      delete :destroy, :format => :json, :id => @geography.village_id, :volunteer_id => @volunteer_user.id
      @geography.reload
      @geography.volunteers.should_not include(@volunteer_user)
    end

  end

end
