# encoding: utf-8
require 'spec_helper'

describe Payment do

  describe "Relations" do
    it { should belong_to(:volunteer) }
  end

  describe "Validations" do
    it { should validate_presence_of(:family_id).with_message("El campo FamilyId es mandatorio") }
    it { should validate_presence_of(:amount).with_message("El monto es mandatorio") }
    it { should validate_presence_of(:date).with_message("La fecha es mandatoria") }
    it { should ensure_length_of(:deposit_number).is_at_most(50).with_long_message("El número de depósito es demasiado largo") }
    it { should ensure_length_of(:deposit_number).is_at_least(4).with_short_message("El número de depósito es demasiado corto") }
    it { should allow_value(nil).for(:deposit_number) }
    it { should validate_numericality_of(:amount)
         .is_greater_than_or_equal_to(0)
         .is_less_than_or_equal_to(10000)
         .with_message("El monto debe ser numérico entre 0 y 10000") }
    it { should validate_numericality_of(:debt)
         .is_greater_than_or_equal_to(0).with_message("El monto pagado no puede ser mayor a la deuda") }
  end

  describe "#has_volunteer" do
    it "should return payments with a volunteer" do
      volunteer = FactoryGirl.create(:volunteer_user)
      payment1 = FactoryGirl.create(:payment, voucher:"2", date:Date.today-5, volunteer_id: nil)
      payment2 = FactoryGirl.create(:payment, voucher:"2", date:Date.today-4, volunteer_id: volunteer.id)

      Payment.has_volunteer.should == [payment2]
    end
  end

  describe "#last_family_payment" do
    it "should return the last family payment by date" do
      payment1 = FactoryGirl.create(:payment, family_id:1, date:Date.today-4)
      payment2 = FactoryGirl.create(:payment, family_id:1,  date:Date.today-5)
      payment3 = FactoryGirl.create(:payment, family_id:2, date:Date.today-2)

      last_payment = Payment.last_family_payment payment1.family_id
      last_payment.should == payment1
    end
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

  describe "#payment_type" do
    it "should return EFECTIVO if there is not a deposit number" do
      payment = FactoryGirl.build(:payment, deposit_number:nil)
      payment.type.should == "EFECTIVO"
    end

    it "should return COMPROBANTE if there is a deposit number" do
      payment = FactoryGirl.build(:payment, deposit_number:"123")
      payment.type.should == "COMPROBANTE"
    end

    it "should return VISITA if amount is zero" do
      payment = FactoryGirl.build(:payment, amount:0, deposit_number:nil)
      payment.type.should == "VISITA"
    end
  end
end
