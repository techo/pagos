# encoding: utf-8
require 'spec_helper'

describe Payment do

    describe "Validations" do
      it { should validate_presence_of(:family_id).with_message("El campo FamilyId es mandatorio") }
      it { should validate_presence_of(:amount).with_message("El monto es mandatorio") }
      it { should validate_presence_of(:date).with_message("La fecha es mandatoria") }
      it { should validate_numericality_of(:amount)
           .is_greater_than_or_equal_to(0)
           .is_less_than_or_equal_to(10000)
           .with_message("El monto debe ser numérico entre 0 y 10000") }
    end
end
