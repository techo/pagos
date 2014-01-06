require "spec_helper"

describe PaymentsManager do
  describe "calculating_debt" do
    it "should return current debt for the specified parameters" do
      charge = "1000"
      pilote_payments = "100"
      debt = PaymentsManager.calculating_debt charge, pilote_payments
      debt.should == 900
    end

    it "should return -1 if charge is lesser than payments" do
      charge = "100"
      pilote_payments = '1000'
      debt = PaymentsManager.calculating_debt charge, pilote_payments
      debt.should == -1
    end
  end
end
