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
    volunteer = FactoryGirl.create(:volunteer_user, first_name:"juan", email:"juanito@report.com")
    payment1 = FactoryGirl.create(:payment, amount:11, date: Date.today-10, volunteer_id:volunteer.id)
    payment2 = FactoryGirl.create(:payment, amount:12, date: Date.today-8, volunteer_id:volunteer.id)
    payment3 = FactoryGirl.create(:payment, amount:13, date: Date.today-6, volunteer_id:volunteer.id)

    expected_payments = [{"initial_balance"=>payment1.amount, "final_balance"=>payment2.amount+payment1.amount},
                         {"initial_balance"=>payment1.amount + payment2.amount, "final_balance"=>payment3.amount+payment2.amount+payment1.amount}]

    let!(:volunteer_user) { FactoryGirl.build(:volunteer_user, id: 1) }

    before (:each) do
      @report = HistoricalPaymentsReport.new
      @report.from = Date.today - 9
      @report.to = Date.today
      @report.generate
    end

    after (:all) do
      Payment.destroy_all
      volunteer.destroy
    end

    it "should add to result the payments between from and to" do
      expect(@report.result.count).to eq 2
      @report.result.each{|record| record["date"].should be_between(@report.from, @report.to) }
    end

    it "every record should have require report information" do
      @report.result.each do |record| 
        expect(record).to include("date")
        expect(record).to include("amount")
        expect(record).to include("deposit_number")
        expect(record).to include("initial_balance")
        expect(record).to include("amount")
        expect(record).to include("final_balance")
      end
    end

    it "should not add to result the pilote payments" do
      pilote_payment = FactoryGirl.create(:payment, amount:50, date: Date.today-5, volunteer_id:nil)
      expect(@report.result.count).to eq 2
      @report.result.each{|record| record["volunteer_id"].should_not be_nil }
    end

    it "should bring the data of the volunteer that registered the payment " do
      @report.result.each{|record| record["volunteer"]["first_name"].should == "juan" }
    end
    
    xit "initial balance should be the cumulated amount previous payment date" do
      expected_payments.each_with_index do |record, index|
        @report.result[index]["initial_balance"].should == record["initial_balance"]
      end
    end


    xit "final balance should be the cumulated amount previous payment date" do
      expected_payments.each_with_index do |record, index|
        @report.result[index]["final_balance"].should == record["final_balance"]
      end
    end

    it "should get families from volunteers's geographies" do
      pending("hay que resolver")
    end

  end
end
