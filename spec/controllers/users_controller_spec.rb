require 'spec_helper'

describe UsersController do

  describe "GET #edit" do
    it "displays the list of registered users" do
      user_1 = User.new
      User.stub(:all).and_return([user_1])

      get :edit
      assigns[:users].should == [user_1]
    end
  end

  describe "POST #update" do
    it "updates a user's role according to the parameters" do
      user = User.create(id: 1, first_name: "R", last_name: "S", email: "r@s.com", password: "1234567890", password_confirmation: "1234567890", role: nil)

      expect {
        post :update, { "user" => { "#{user.id}" => { "role" => "volunteer" } } }
      }.to change{user.reload.role}.to("volunteer")
    end

    it "redirects to the edit page" do
      post :update, "user"=>{}
      response.should redirect_to action: 'edit'
    end

  end
end
