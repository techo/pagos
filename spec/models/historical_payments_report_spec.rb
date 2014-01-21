require 'spec_helper'

describe HistoricalPaymentsReport do

  describe "#initialize" do
    it "should set to date with current date" do
      report = HistoricalPaymentsReport.new
      report.to.should == Date.today
    end

    it "should set from date with beginning of current month" do
      report = HistoricalPaymentsReport.new
      report.from.should == Date.today.beginning_of_month
    end

  end

  describe "#generate" do

    before (:each) do
      @volunteer = FactoryGirl.create(:volunteer_user, first_name:"juan", email:"juanito@report.com")
      payment1 = FactoryGirl.create(:payment, amount:11, date: Date.today-10, volunteer_id:@volunteer.id, family_id:1)
      payment2 = FactoryGirl.create(:payment, amount:12, date: Date.today-8, volunteer_id:@volunteer.id, family_id:2)
      payment3 = FactoryGirl.create(:payment, amount:13, date: Date.today-6, volunteer_id:@volunteer.id, family_id:1)

      @expected_payments =
        [{"initial_balance"=>0, "final_balance"=>payment2.amount, "family_head"=>"Ramon", "asentamiento"=>"Cotocollao"},
         {"initial_balance"=>payment1.amount, "final_balance"=>payment3.amount+payment1.amount, "family_head"=>"Teresa", "asentamiento"=>"Collana",}]

      families_details = [{"id_de_familia"=>"1","jefe_de_familia"=>"Teresa","monto_original"=>"120.00","asentamiento"=>"Collana","pagos"=>"60.00"},
                          {"id_de_familia"=>"2","jefe_de_familia"=>"Ramon","monto_original"=>"120.00","asentamiento"=>"Cotocollao","pagos"=>"60.00"}]
      PiloteHelper.stub(:get_families_details).with([2, 1]).and_return(families_details)

      @report = HistoricalPaymentsReport.new
      @report.from = Date.today - 9
      @report.to = Date.today
      @report.generate
    end

    it "should add to result the payments between from and to" do
      expect(@report.result.count).to eq 2
      @report.result.each{|record| record["date"].should be_between(@report.from, @report.to) }
    end

    it "every record should have require report information" do
      @report.result.each do |record|
        record.should include("date")
        record.should include("amount")
        record.should include("deposit_number")
        record.should include("initial_balance")
        record.should include("final_balance")
        record.should include("amount")
      end
    end

    it "should not add payments from pilote to the report" do
      pilote_payment = FactoryGirl.create(:payment, amount:50, date: Date.today-5, volunteer_id:nil)
      expect(@report.result.count).to eq 2
    end

    it "should include the volunteer that registered the payment " do
      @report.result.each do |record|
        record["volunteer"]["first_name"].should == "juan"
      end
    end

    it "initial balance should be the cumulated amount previous payment date" do
      @report.result.count.should == 2
    end

    it "initial balance should be the cumulated amount previous payment date" do
      @expected_payments.each_with_index do |record, index|
        @report.result[index]["initial_balance"].should == record["initial_balance"]
      end
    end

    it "final balance should be the cumulated amount previous payment date" do
      @expected_payments.each_with_index do |record, index|
        @report.result[index]["final_balance"].should == record["final_balance"]
      end
    end

    it "should include head of family for each payment" do
      @expected_payments.each_with_index do |record, index|
        @report.result[index]["family_head"].should == record["family_head"]
      end
    end

    it "should include geography of family for each payment" do
      @expected_payments.each_with_index do |record, index|
        @report.result[index]["geography"].should == record["asentamiento"]
      end
    end

    xit "should include original cost of house for each payment" do
      @expected_payments.each_with_index do |record, index|
        @report.result[index]["geography"].should == record["asentamiento"]
      end
    end
  end
end
