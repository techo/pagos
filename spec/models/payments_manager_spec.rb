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

    it "should save a first payment if not registered with pilote info" do
      family = {"id_de_familia" => "1", "monto_original" => "200", "pagos" => "50"}
      @join = double(ActiveRecord::Relation)
      @join.stub(:count).and_return(0)
      Payment.stub(:where).with(:family_id => 1).and_return(@join)
      Payment.should_receive(:create).with(family_id: 1, amount: 50, voucher: "pilote", date: Date.today - 1)
      PaymentsManager.calculating_debt family
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

  describe "#save_payment" do

    let!(:valid_payment) { FactoryGirl.build(:valid_payment, date: Date.today) }
    let!(:invalid_payment) { FactoryGirl.build(:invalid_payment) }
    let!(:volunteer) { FactoryGirl.create(:volunteer) }
    let!(:manager) { PaymentsManager.new }

    before(:all) do
    end

    it "should assigns the payment to the volunteer" do
      set_pilote_correct_answer
      manager.save_payment valid_payment, volunteer
      valid_payment.volunteer.should == volunteer
    end

    it "should save a valid payment" do
      set_pilote_correct_answer
      expect{
        manager.save_payment valid_payment, volunteer
      }.to change{ Payment.count }.by(1)
    end

    it "should not save an invalid payment" do
      expect{
        manager.save_payment invalid_payment, volunteer
      }.to change{ Payment.count }.by(0)
    end

    it "should return true if payment was saved" do
      set_pilote_correct_answer
      manager.save_payment(valid_payment, volunteer).should == true
    end

    it "should return false if payment is not valid" do
      manager.save_payment(invalid_payment, volunteer).should == false
    end

    it "should save the payment with the previous debt" do
      set_pilote_correct_answer
      manager.save_payment valid_payment, volunteer
      valid_payment.debt.should == 60
    end

    it "should register the payment in pilote" do
      pending("not implemented")
    end

    it "should not save payment if pilote sync fails" do
      pending("not implemented")
    end

    it "should add valid a payment to a volunteer" do
      pending("not implemented")
    end

  end

  def set_pilote_correct_answer
    pilote_response = [{"id_de_familia"=>56602,"jefe_de_familia"=>"Maria Rosario Fernandez Duchitanga","monto_original"=>120.00,"asentamiento"=>"Collana","ciudad"=>"Ludo, Sigsig","provincia"=>"Azuay","pagos"=>60.00}]
    PiloteHelper.stub(:get_families_details).and_return(pilote_response)
  end
end
