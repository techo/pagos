require 'spec_helper'

describe Volunteer do
  describe 'properties' do
    it { should be_a(User) }
    it { should have_many(:geographies)  }
    it { should have_many(:payments)  }
  end

  describe '#volunteers' do
    let!(:volunteer_user) { FactoryGirl.build(:volunteer_user, first_name: "pedro") }
    let!(:volunteer_additional_user) { FactoryGirl.build(:volunteer_additional_user, first_name: "maria") }
    let!(:administrator_user) { FactoryGirl.build(:administrator_user, first_name: "juan") }

    after (:all) do
      User.destroy_all
    end

    it "should have the volunteers in the right order" do
      volunteer_user.save
      administrator_user.save
      volunteer_additional_user.save

      Volunteer.all.should == [volunteer_additional_user.becomes(Volunteer), volunteer_user.becomes(Volunteer)]
    end

  end

end
