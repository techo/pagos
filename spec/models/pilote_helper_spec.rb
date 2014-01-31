# encoding: UTF-8

require "spec_helper"

describe PiloteHelper do
  describe "Families" do
    let!(:volunteer_user) { FactoryGirl.build(:volunteer_user, id: 1) }
    let!(:path) { "#{PiloteHelper::GET_FAMILIES_FOR_GEOGRAPHIES_PATH}1)" }
    let!(:families_details_path) { "#{PiloteHelper::GET_FAMILIES_FOR_IDS}" }

    it "should wrap into array if users is singular" do
      PiloteHelper.should_receive(:compose_pilote_families_path).with([volunteer_user])
      PiloteHelper.get_families volunteer_user
    end

    it "should request the families of a set of geographies" do
      PiloteHelper.stub(:compose_pilote_families_path).and_return(path)
      Net::HTTP.stub(:get).and_return({})
      Net::HTTP.any_instance.should_receive(:request)
      PiloteHelper.get_families volunteer_user
    end

    it "should handle families request failures" do
      Net::HTTP.stub(:get).and_raise(Errno::ECONNREFUSED)
      Rails.logger.should_receive(:error)
      families = PiloteHelper.get_families volunteer_user
      families.has_key?(:error).should == true
    end

    it "should encoding head of families name" do
      PiloteHelper.stub(:compose_pilote_families_path).and_return(path)
      pilote_families = '[{"asentamiento":"A", "jefe_de_familia":"To\u00c3\u00b1o"}, {"asentamiento":"Z", "jefe_de_familia":"Juan"}, {"asentamiento":"A", "jefe_de_familia":"Z"}]'
      Net::HTTP.any_instance.stub(:request).and_return(stub(body: pilote_families))

      families = PiloteHelper.get_families(volunteer_user)
      families["A"][0]["jefe_de_familia"].should == "Toño"
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

  describe "Families details" do
    it "should request the families details given a set of families ids" do
      Net::HTTP.any_instance.
        should_receive(:request).
        with(an_instance_of(Net::HTTP::Post)).and_return(stub(body: "{}"))
      PiloteHelper.get_families_details [1,2,3]
    end

    it "should return a hash of families details" do
      expected_families =
        '[{"id_de_familia":"56602","jefe_de_familia":"Maria","monto_original":"120.00","asentamiento":"Collana","pagos":"60.00"},
          {"id_de_familia":"56606","jefe_de_familia":"Delfilia","monto_original":"120.00","asentamiento":"Collana","pagos":"60.00"}]'
      response = double(Net::HTTPSuccess, is_a?: false)
      response.stub(:body).and_return(expected_families)
      PiloteHelper.stub(:make_https_request).and_return(response)
      PiloteHelper.get_families_details([1, 2]).should == JSON.parse(expected_families)
    end

    it "should make a request with a list of family ids" do
      Net::HTTP.any_instance.stub(:request).and_return(stub(body: "{}"))
      Net::HTTP::Post.any_instance.should_receive(:set_form_data).with({"idFamilias"=>"(1, 2)", "idPais"=>"#{ENV["PILOTE_COUNTRY_CODE"]}"})
      PiloteHelper.get_families_details [1,2]
    end

    it "should encoding head of families name" do
      pilote_families =
        '[{"id_de_familia":"1","jefe_de_familia":"To\u00c3\u00b1o","monto_original":"120.00","asentamiento":"Collana","pagos":"60.00"}]'
        response = double(Net::HTTPSuccess, is_a?: false)
      response.stub(:body).and_return(pilote_families)
      PiloteHelper.stub(:make_https_request).and_return(response)
      families = PiloteHelper.get_families_details([1])
      families[0]["jefe_de_familia"].should == "Toño"
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

      path.should == "#{PiloteHelper::GET_FAMILIES_FOR_GEOGRAPHIES_PATH}(#{geography.village_id})&pais=#{ENV["PILOTE_COUNTRY_CODE"]}"
    end
  end

  describe "#save_pilote_payment" do

    before (:each) do
      @pilote_payment = {"familia"=>"1", "cantidad"=>"2", "fecha"=>"2014-10-10", "voucher"=>"123", "comentario"=>"ninguno" }
    end

    it "should post a payment in pilote" do
      Net::HTTP.any_instance.
        should_receive(:request).
        with(an_instance_of(Net::HTTP::Post)).and_return(stub(body: "{}"))
      PiloteHelper.save_pilote_payment @pilote_payment
    end

    it "should make a request with payment data" do
      Net::HTTP.any_instance.stub(:request).and_return(stub(body: "{}"))
      Net::HTTP::Post.any_instance.should_receive(:set_form_data).with(@pilote_payment)
      PiloteHelper.save_pilote_payment @pilote_payment
    end

    it "should return true if response is successful" do
      response = double(Net::HTTPSuccess, is_a?: true)
      response.stub(:body).and_return("{response:ok}")
      Net::HTTP.any_instance.stub(:request).and_return(response)
      Net::HTTP::Post.any_instance.stub(:set_form_data).with(@pilote_payment)
      result = PiloteHelper.save_pilote_payment @pilote_payment
      result.should == true
    end

    it "should return false if response has errors" do
      response = double(Net::HTTPSuccess, is_a?: false)
      response.stub(:body).and_return( "{error:true}")
      Net::HTTP.any_instance.stub(:request).and_return(response)
      Net::HTTP::Post.any_instance.stub(:set_form_data).with(@pilote_payment)
      result = PiloteHelper.save_pilote_payment @pilote_payment
      result.should == false
    end

    it "should not attempt to save if in integration environment" do
      ENV["IS_INTEGRATION"] = 'true'
      Net::HTTP.any_instance.should_not_receive(:request)
      PiloteHelper.save_pilote_payment(@pilote_payment)
    end

    it "should not attempt to save if in integration environment" do
      ENV["IS_INTEGRATION"] = 'true'
      Rails.logger.should_receive(:info).with("Saving Pilote payment: #{@pilote_payment.inspect}")
      PiloteHelper.save_pilote_payment(@pilote_payment)
    end
  end
end
