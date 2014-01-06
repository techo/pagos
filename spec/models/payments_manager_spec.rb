require "spec_helper"

describe PaymentsManager do
  describe "calculating_debt" do
    it "should return current debt for the specified parameters" do
      family = {"id_de_familia" => "1", "monto_original" => "200", "pagos" => "50"}
      debt = PaymentsManager.calculating_debt family
      debt.should == 150
    end

    it "should return -1 if charge is lesser than payments" do
      family = {"id_de_familia" => "1", "monto_original" => "100", "pagos" => "1000"}
      debt = PaymentsManager.calculating_debt family
      debt.should == -1
    end

    it "should save a first payment if it is not registered locally" do
      family = {"id_de_familia" => "1", "monto_original" => "200", "pagos" => "50"}
      @join = double(ActiveRecord::Relation)
      @join.stub(:count).and_return(0)
      Payment.should_receive(:where).with(:family_id => 1).and_return(@join)
      expect {
        debt = PaymentsManager.calculating_debt family
      }.to change{Payment.count }.by(1)
    end

    it "should not save any payment if it is registered locally" do
      family = {"id_de_familia" => "1", "monto_original" => "200", "pagos" => "50"}
      @join = double(ActiveRecord::Relation)
      @join.stub(:count).and_return(2)
      @join.should_receive(:sum).with(:amount).and_return(100)
      Payment.should_receive(:where).with(:family_id => 1).and_return(@join)
      expect {
        debt = PaymentsManager.calculating_debt family
      }.to change{Payment.count }.by(0)
    end

    it "should take off from the debt the local payments" do
      family = {"id_de_familia" => "1", "monto_original" => "200", "pagos" => "50"}
      @join = double(ActiveRecord::Relation)
      @join.stub(:count).and_return(2)
      @join.should_receive(:sum).with(:amount).and_return(150)
      Payment.stub(:where).with(:family_id => 1).and_return(@join)

      debt = PaymentsManager.calculating_debt family
      debt.should == 50
    end
  end
end
