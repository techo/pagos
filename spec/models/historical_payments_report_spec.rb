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
      @volunteer = FactoryGirl.create(:volunteer_user, first_name:"juan", last_name:"perez", email:"juanito@report.com")
      payment1 = FactoryGirl.create(:payment, amount:11, voucher:"23", date: Date.today-10, volunteer_id:@volunteer.id, family_id:1, debt:189)
      payment2 = FactoryGirl.create(:payment, amount:12, voucher:"23", date: Date.today-8, volunteer_id:@volunteer.id, family_id:2, deposit_number:"1234", debt:168)
      payment3 = FactoryGirl.create(:payment, amount:13, voucher:"23", date: Date.today-6, volunteer_id:@volunteer.id, family_id:1, debt:176)
      payment4 = FactoryGirl.create(:payment, amount:0, voucher:nil, date: Date.today-7, volunteer_id:@volunteer.id, family_id:1, debt:189)

      @expected_payments =
        [ {"initial_balance"=>189, "final_balance"=>189, "family_head"=>"Teresa", "asentamiento"=>"Collana", "ciudad" => "Montecristi", "provincia" => "Manabi", "deposit_number"=>"VISITA"},
          {"initial_balance"=>189, "final_balance"=>176, "family_head"=>"Teresa", "asentamiento"=>"Collana", "ciudad" => "Montecristi", "provincia" => "Manabi", "deposit_number"=>"EFECTIVO"},
          {"initial_balance"=>180, "final_balance"=>168, "family_head"=>"Ramon", "asentamiento"=>"Cotocollao", "ciudad" => "Montecristi", "provincia" => "Manabi", "deposit_number"=>"1234" }]

      families_details = [{"id_de_familia"=>"1","jefe_de_familia"=>"Teresa","asentamiento"=>"Collana", "ciudad" => "Montecristi", "provincia" => "Manabi"},
                          {"id_de_familia"=>"2","jefe_de_familia"=>"Ramon","asentamiento"=>"Cotocollao", "ciudad" => "Montecristi", "provincia" => "Manabi"}]
      PiloteHelper.stub(:get_families_details).with([2, 1]).and_return(families_details)

      @report = HistoricalPaymentsReport.new
      @report.from = Date.today - 9
      @report.to = Date.today
      @report.generate
    end

    it "should add to result the payments between from and to" do
      expect(@report.result.count).to eq 3
      @report.result.each{|record| Date.parse(record["date"]).should be_between(@report.from, @report.to) }
    end

    it "should not add payments from pilote to the report" do
      pilote_payment = FactoryGirl.create(:payment, amount:50, voucher:"23", date: Date.today-5, volunteer_id:nil)
      expect(@report.result.count).to eq 3
    end

    it "should include the volunteer that registered the payment " do
      @report.result.each do |record|
        record["volunteer"].should == "juan perez"
      end
    end

    it "initial balance should be the cumulated amount previous payment date" do
      @report.result.count.should == 3
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
        @report.result[index]["geography"].should == "#{record["provincia"]} - #{record["ciudad"]} - #{record["asentamiento"]}"
      end
    end

    it "should include original cost of house for each payment" do
      @expected_payments.each_with_index do |record, index|
        @report.result[index]["original_cost"].should == record["cobro"]
      end
    end

    it "if the payment is in cash deposit number should be EFECTIVO" do
      @expected_payments.each_with_index do |record, index|
        @report.result[index]["receipt"].should == record["deposit_number"]
      end
    end

    it "if the payment was a visit the deposit number should be EFECTIVO" do
      @expected_payments.each_with_index do |record, index|
        @report.result[index]["receipt"].should == record["deposit_number"]
      end
    end
  end

  describe "Sorted results" do
    before (:each) do
      @volunteer = FactoryGirl.create(:volunteer_user, first_name:"juan", last_name:"perez", email:"juanito@report.com")
      payment1 = FactoryGirl.create(:payment, amount:11, date: Date.today-10, volunteer_id:@volunteer.id, family_id:1)
      payment2 = FactoryGirl.create(:payment, amount:12, date: Date.today-8, volunteer_id:@volunteer.id, family_id:2, deposit_number:"1234")
      payment3 = FactoryGirl.create(:payment, amount:13, date: Date.today-6, volunteer_id:@volunteer.id, family_id:1)
      payment4 = FactoryGirl.create(:payment, amount:13, date: Date.today-6, volunteer_id:@volunteer.id, family_id:3)

      @expected_payments =
        [{"initial_balance"=>180, "final_balance"=>168, "family_head"=>"Ramon", "asentamiento"=>"Cotocollao", "ciudad" => "Montecristi", "provincia" => "Manabi", "cobro"=>"180.00", "deposit_number"=>"1234" },
         {"initial_balance"=>189, "final_balance"=>176, "family_head"=>"Teresa", "asentamiento"=>"Quito", "ciudad" => "Montecristi", "provincia" => "Manabi", "cobro"=>"200.00", "deposit_number"=>"EFECTIVO"},
         {"initial_balance"=>189, "final_balance"=>176, "family_head"=>"Diana", "asentamiento"=>"Collana", "ciudad" => "Montecristi", "provincia" => "Manabi", "cobro"=>"200.00", "deposit_number"=>"EFECTIVO"}]

      families_details = [{"id_de_familia"=>"1","jefe_de_familia"=>"Teresa","monto_original"=>"200.00","asentamiento"=>"Quito", "ciudad" => "Montecristi", "provincia" => "Manabi","pagos"=>"60.00"},
                          {"id_de_familia"=>"2","jefe_de_familia"=>"Ramon","monto_original"=>"180.00","asentamiento"=>"Cotocollao", "ciudad" => "Montecristi", "provincia" => "Manabi","pagos"=>"60.00"},
                          {"id_de_familia"=>"3","jefe_de_familia"=>"Diana","monto_original"=>"180.00","asentamiento"=>"Cotocollao", "ciudad" => "Montecristi", "provincia" => "Manabi","pagos"=>"60.00"}]
      PiloteHelper.stub(:get_families_details).with([1, 2, 3]).and_return(families_details)

      @report = HistoricalPaymentsReport.new
      @report.from = Date.today - 11
      @report.to = Date.today
      @report.generate
    end

    it "should return results sorted first by geography then family name then date of payment" do
      order = [{
                "geography"=>    "Manabi - Montecristi - Cotocollao",
                "family_head"=>  "Diana",
                "date"=>         Date.today-6
              },
              {
                "geography"=>    "Manabi - Montecristi - Cotocollao",
                "family_head"=>  "Ramon",
                "date"=>         Date.today-8
              },
              {
                "geography"=>    "Manabi - Montecristi - Quito",
                "family_head"=>  "Teresa",
                "date"=>         Date.today-10
              },
              {
                "geography"=>    "Manabi - Montecristi - Quito",
                "family_head"=>  "Teresa",
                "date"=>         Date.today-6
              }]
      order.each_with_index do |details, index|
        result = @report.result[index]
        details.each do |key, value|
          if key == 'date'
            Date.parse(result[key]).should == value
          else
            result[key].should == value
          end
        end
      end
    end
  end

  describe "Empty results" do
    it "should not get families details from pilote if there is not payments in the range" do
      HistoricalPaymentsReport.any_instance.should_not_receive(:add_pilote_info)
      @report = HistoricalPaymentsReport.new
      @report.from = Date.today - 9
      @report.to = Date.today
      @report.generate
    end
  end
end
