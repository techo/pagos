require "spec_helper"

describe PiloteHelper do
  describe "Families" do
    it "should receive the families of a geographies set" do
      uri = URI.parse(PiloteHelper::GET_FAMILIES_FOR_GEOGRAPHIES_PATH)
      Net::HTTP.should_receive(:get).with(uri).and_return("{}")
      PiloteHelper.get_families
    end

    it "should handle families request failures" do
      Net::HTTP.stub(:get).and_raise(Errno::ECONNREFUSED)
      PiloteHelper.get_families.should == JSON.parse("{}")
    end

    it "should return sorted families by jefe_de_familia" do
      uri = URI.parse(PiloteHelper::GET_FAMILIES_FOR_GEOGRAPHIES_PATH)
      families = '[{"jefe_de_familia":"Juan"}, {"jefe_de_familia":"Angel"}, {"jefe_de_familia":"Raul"}]'
      sorted_families = '[{"jefe_de_familia":"Angel"}, {"jefe_de_familia":"Juan"}, {"jefe_de_familia":"Raul"}]'
      Net::HTTP.should_receive(:get).with(uri).and_return(families)
      PiloteHelper.get_families.should == JSON.parse(sorted_families)
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
end
