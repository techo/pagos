require 'spec_helper'

describe UsersController do

  after (:all) do
    User.all
  end

  describe "before filter" do
    it "redirects to root url if the current user cannot manage users" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:volunteer_user)

      get :edit
      response.should redirect_to root_url
    end

    it "redirects if there is no current user" do
      get :edit
      response.should redirect_to root_url
    end

    it "does not redirect to root url if the current user can manage users" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)

      get :edit
      response.should_not be_redirect
    end
  end

  describe "GET #edit" do
    it "displays the list of registered users" do
      user = FactoryGirl.create(:administrator_user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user

      users = [user]
      User.stub(:all).and_return(users)
      users.stub_chain(:where, :first).and_return(user) # Disgusting stub for current_user

      get :edit
      assigns[:users].should == [user]
    end
  end

  describe "POST #update" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)
    end

    it "updates a user's role according to the parameters" do
      user = FactoryGirl.create(:user_without_role, email: "n@n.com")

      expect {
        post :update, { "user" => { "#{user.id}" => { "role" => "voluntario" } } }
      }.to change{user.reload.role}.to("voluntario")
    end

    it "redirects to the edit page" do
      post :update, "user"=>{}
      response.should redirect_to action: 'edit'
    end

    it "displays a flash message on success" do
      user = FactoryGirl.create(:user_without_role, email: "n@n.com")
      post :update, { "user" => { "#{user.id}" => { "role" => "voluntario" } } }
      flash[:success].should == "Los roles han sido grabados correctamente."
    end
  end

  describe "GET #get_volunteers" do
    it "displays the list of registered volunteers" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)

      user = FactoryGirl.create(:volunteer_user)

      users = [user.becomes(Volunteer)]
      Volunteer.stub(:all).and_return(users)
      users.stub_chain(:where).and_return(user) # Disgusting stub for current_user

      get :volunteers

      response.body.should == users.to_json
    end
  end
end
