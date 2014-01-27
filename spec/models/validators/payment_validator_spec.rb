require 'spec_helper'

describe Validators::PaymentValidator do

  describe "#validate" do

    it "should be valid if has voucher when amount > 0" do
      payment = Payment.new(family_id: 1, date: Date.today, voucher: "102", amount: 10, debt: 10)
      payment.should be_valid
    end

    it "should be invalid if no voucher when amount > 0" do
      payment = Payment.new(family_id: 1, date: Date.today, amount: 10)
      payment.should_not be_valid
    end

    it "should return message if no voucher when amount > 0" do
      payment = Payment.new(family_id: 1, date: Date.today, amount: 10)
      payment.valid?
      payment.errors.messages[:voucher].should include("El voucher es mandatorio")
    end
  end
end

