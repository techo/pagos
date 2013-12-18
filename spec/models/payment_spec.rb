require 'spec_helper'

describe Payment do

    describe "Validations" do
      it { should validate_presence_of(:family_id).with_message("El campo FamilyId es mandatorio") }
      it { should validate_presence_of(:amount).with_message("El campo Amount es mandatorio") }
      it { should validate_presence_of(:date).with_message("El campo Date es mandatorio") }
    end
end
