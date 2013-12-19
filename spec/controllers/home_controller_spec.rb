require 'spec_helper'

describe HomeController do
  describe 'GET #index' do
    it 'redirects to edit_users if user can manage users' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:administrator_user)
      get :index
      response.should redirect_to users_path
    end

    it 'does not redirect to edit_users if user cannot manage users' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:volunteer_user)
      get :index
      response.should_not redirect_to users_path
    end

    it "redirects to payments if user can manage payments" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:volunteer_user)
      get :index
      response.should redirect_to payments_path
    end
  end

end
