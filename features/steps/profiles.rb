class Spinach::Features::Profiles < Spinach::FeatureSteps
  step 'I change role of volunteer to administrator' do
    @page = Page::Profile.new
    @page.change_role_to("Administrador", @volunteer)
  end

  step 'I should see his role is changed in database as well' do
    @volunteer.reload
    @volunteer.role.must_equal "administrador"
  end

  step 'I am logged in as an administrator' do
    @admin = FactoryGirl.create(:administrator_user)
    @page = Page::Login.new(@admin.email, @admin.password)
    @page.login
    @page.login_success?.must_equal true
  end

  step 'I have few volunteers' do
    @volunteer = FactoryGirl.create(:volunteer_user)
  end
end
