require "spec_helper"

describe PiloteHelper do
  describe "Families" do
    let!(:volunteer_user) { FactoryGirl.build(:volunteer_user, id: 1) }
    let!(:uri) { URI.parse("#{PiloteHelper::GET_FAMILIES_FOR_GEOGRAPHIES_PATH}1)") }
    
    it "should receive the families of a geographies set" do
      PiloteHelper.should_receive(:compose_pilote_families_uri).and_return(uri)
      Net::HTTP.should_receive(:get).with(uri).and_return("{}")
      PiloteHelper.get_families volunteer_user
    end

    it "should handle families request failures" do
      Net::HTTP.stub(:get).and_raise(Errno::ECONNREFUSED)
      families = PiloteHelper.get_families volunteer_user
      families.should == JSON.parse("{}")
    end

    it "should return sorted families by jefe_de_familia" do
      PiloteHelper.should_receive(:compose_pilote_families_uri).and_return(uri)
      families = '[{"jefe_de_familia":"Juan"}, {"jefe_de_familia":"Angel"}, {"jefe_de_familia":"Raul"}]'
      sorted_families = '[{"jefe_de_familia":"Angel"}, {"jefe_de_familia":"Juan"}, {"jefe_de_familia":"Raul"}]'
      Net::HTTP.should_receive(:get).with(uri).and_return(families)
      families = PiloteHelper.get_families volunteer_user
      families.should == JSON.parse(sorted_families)
    end
  end

  describe "geographies" do
    it "should request geoghaphies from pilote API" do
      uri = URI.parse(PiloteHelper::GET_GEOGRAPHIES_PATH)
      Net::HTTP.should_receive(:get).with(uri).and_return("{}")
      PiloteHelper.get_geographies
    end

    it "should handle families request failures" do
      Net::HTTP.stub(:get).and_raise(Errno::ECONNREFUSED)
      PiloteHelper.get_geographies.should == JSON.parse("{}")
    end
  end

  describe "compose_pilote_uri" do
    it "should get the geographies assigned to the current user" do
      volunteer_user = FactoryGirl.build(:volunteer_user, id: 1)
      geography = FactoryGirl.build(:geography, village_id: 1234)
      User.stub(:find).with(volunteer_user.id).and_return(volunteer_user)
      User.any_instance.stub(:becomes).with(Volunteer).and_return(volunteer_user)
      volunteer_user.should_receive(:geographies).and_return([geography])

      uri = PiloteHelper.compose_pilote_families_uri volunteer_user.id
      uri.should == URI.parse("#{PiloteHelper::GET_FAMILIES_FOR_GEOGRAPHIES_PATH}(#{geography.village_id})")
    end
  end
end
