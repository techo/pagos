require "spec_helper"

describe PiloteHelper do
  describe "Families" do
    let!(:volunteer_user) { FactoryGirl.build(:volunteer_user, id: 1) }
    let!(:path) { "#{PiloteHelper::GET_FAMILIES_FOR_GEOGRAPHIES_PATH}1)" }

    it "should request the families of a set of geographies" do
      PiloteHelper.stub(:compose_pilote_families_path).and_return(path)
      Net::HTTP.stub(:get).and_return({})
      Net::HTTP.any_instance.should_receive(:request)
      PiloteHelper.get_families volunteer_user
    end

    it "should handle families request failures" do
      Net::HTTP.stub(:get).and_raise(Errno::ECONNREFUSED)
      families = PiloteHelper.get_families volunteer_user
      families.should == JSON.parse("{}")
    end

    it "should return sorted families grouped by geografia" do
      PiloteHelper.stub(:compose_pilote_families_path).and_return(path)
      expected_families = '[{"asentamiento":"A", "jefe_de_familia":"Juan"}, {"asentamiento":"Z", "jefe_de_familia":"Juan"}, {"asentamiento":"A", "jefe_de_familia":"Z"}]'
      Net::HTTP.any_instance.stub(:request).and_return(stub(body: expected_families))

      families = PiloteHelper.get_families(volunteer_user)
      families["A"].should == [{"asentamiento"=>"A", "jefe_de_familia"=>"Juan"}, {"asentamiento"=>"A", "jefe_de_familia"=>"Z"}]
      families["Z"].should == [{"asentamiento"=>"Z", "jefe_de_familia"=>"Juan"}]
    end
  end

  describe "geographies" do
    it "should request geographies from pilote API" do
      path = URI.parse(PiloteHelper::GET_GEOGRAPHIES_PATH)
      Net::HTTP.stub(:get).and_return({})
      Net::HTTP.any_instance.should_receive(:request).and_return("{}")
      PiloteHelper.get_geographies
    end

    it "should handle families request failures" do
      Net::HTTP.stub(:get).and_raise(Errno::ECONNREFUSED)
      PiloteHelper.get_geographies.should == JSON.parse("{}")
    end
  end

  describe "compose_pilote_path" do
    it "should return path to get geographies assigned to the passed users" do
      volunteer_user = FactoryGirl.build(:volunteer_user, id: 1)
      geography = FactoryGirl.build(:geography, village_id: 1234)
      User.stub(:find).with(volunteer_user.id).and_return(volunteer_user)
      User.any_instance.stub(:becomes).with(Volunteer).and_return(volunteer_user)
      volunteer_user.should_receive(:geographies).and_return([geography])

      path = PiloteHelper.compose_pilote_families_path [volunteer_user]

      path.should == "#{PiloteHelper::GET_FAMILIES_FOR_GEOGRAPHIES_PATH}(#{geography.village_id})"
    end
  end
end
