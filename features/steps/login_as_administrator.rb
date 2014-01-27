class Spinach::Features::LoginAsAdministrator < Spinach::FeatureSteps
  step 'there is a registered administrator' do
    @admin = FactoryGirl.create(:administrator_user)
  end

  step 'I login as an administrator' do
    @page = Page::Login.new(@admin.email, @admin.password)
    @page.login
  end

  step 'I should see the success message' do
    @page.login_success?.must_equal true
  end
end
