class Spinach::Features::Assignments < Spinach::FeatureSteps
  step 'I am on the assignments page' do
    @page = Page::Assignment.new
  end

  step 'I should see the provinces displayed in a dropdown box' do
    @page.provinces_listed?.must_equal true
  end

  step 'I select province from the dropdown' do
    @page.select_province("PROVINCE")
  end

  step 'I should see the list of locations under that province' do
    @page.locations_listed?.must_equal true
  end

  step 'I select a location' do
    @page.select_location("CIUDAD - LOCATION")
  end

  step 'I should see all the associated with that location' do
    @page.volunteers_associated(0).must_equal true
  end

  step 'I select the checkbox of a volunteer' do
    @page.assign_volunteer(@volunteer2)
  end

  step 'the volunteer is automatically assigned to that location' do
    sleep(1)
    @volunteer2.assignments.count.must_equal 1
  end

  step 'I am logged in as an administrator' do
    @admin = FactoryGirl.create(:administrator_user)
    @page = Page::Login.new(@admin.email, @admin.password)
    @page.login
    @page.login_success?.must_equal true
  end

  step 'I have few volunteers' do
    @volunteer1 = FactoryGirl.create(:volunteer_user)
    @volunteer2 = FactoryGirl.create(:volunteer_user, first_name: "Zofia la coja", email: 'pepe@gmail.com')

  end

  step 'the list of volunteers is ordered in selected volunteers first' do
    @page.first_volunteer_is_selected?.must_equal true
  end
end
