# encoding: utf-8
require 'spec_helper'

describe Payment do

  describe "Validations" do
    it { should validate_presence_of(:family_id).with_message("El campo FamilyId es mandatorio") }
    it { should validate_presence_of(:amount).with_message("El monto es mandatorio") }
    it { should validate_presence_of(:date).with_message("La fecha es mandatoria") }
    it { should ensure_length_of(:deposit_number).is_at_most(50).with_long_message("El número de depósito es demasiado largo") }
    it { should validate_numericality_of(:amount)
         .is_greater_than_or_equal_to(0)
         .is_less_than_or_equal_to(10000)
         .with_message("El monto debe ser numérico entre 0 y 10000") }
  end

  describe "#within_range" do
    it "should return payments within a range" do
      payment1 = FactoryGirl.create(:payment, date:Date.today-5)
      payment2 = FactoryGirl.create(:payment, date:Date.today-4)
      payment3 = FactoryGirl.create(:payment, date:Date.today-2)

      payments = Payment.within_range Date.today-4, Date.today
      payments.should == [payment2, payment3]
    end

    it "should return payments including current day" do
      payment = FactoryGirl.create(:payment, date:DateTime.now)

      payments = Payment.within_range Date.today-4, Date.today
      payments.should == [payment]
    end
  end
end
