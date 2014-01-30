require "spec_helper"

describe PaymentsManager do

  describe "#save_payment" do

    let!(:valid_payment) { FactoryGirl.build(:valid_payment, date: Date.today) }
    let!(:invalid_payment) { FactoryGirl.build(:invalid_payment) }
    let!(:volunteer) { FactoryGirl.create(:volunteer) }
    let!(:manager) { PaymentsManager.new }

    before(:each) do
      PiloteHelper.stub(:save_pilote_payment).and_return(true)
      PiloteHelper.stub(:make_https_request)
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
      set_pilote_correct_answer
      expect{
        manager.save_payment invalid_payment, volunteer
      }.to change{ Payment.count }.by(0)
    end

    it "should return true if payment was saved" do
      set_pilote_correct_answer
      manager.save_payment(valid_payment, volunteer).should == true
    end

    it "should return false if payment is not valid" do
      set_pilote_correct_answer
      manager.save_payment(invalid_payment, volunteer).should == false
    end

    it "should save the payment with the previous debt" do
      set_pilote_correct_answer
      manager.save_payment valid_payment, volunteer
      valid_payment.debt.should == 60 - valid_payment.amount
    end

    it "should set debt with previous existing debt minus the payment amount" do
      previous_payment = double(Payment)
      previous_payment.stub(:debt).and_return(50)
      Payment.stub(:last_family_payment).with(valid_payment.family_id).and_return(previous_payment)
      manager.save_payment valid_payment, volunteer
      valid_payment.debt.should == previous_payment.debt - valid_payment.amount
    end

    it "should register a cash payment in pilote" do
      pilote_payment = setup_pilote_payment_sync("EFECTIVO")
      PiloteHelper.should_receive(:save_pilote_payment).with(pilote_payment)
      manager.save_payment valid_payment, volunteer
    end

    it "should register a deposit payment in pilote" do
      valid_payment.deposit_number = "12345"
      valid_payment.voucher = "12345"
      pilote_payment = setup_pilote_payment_sync("COMPROBANTE")
      PiloteHelper.should_receive(:save_pilote_payment).with(pilote_payment)

      manager.save_payment valid_payment, volunteer
    end

    it "should not register a visit in pilote" do
      set_pilote_correct_answer
      valid_payment.amount = 0
      valid_payment.deposit_number = nil
      PiloteHelper.should_not_receive(:save_pilote_payment)

      manager.save_payment valid_payment, volunteer
    end

    it "should not save payment if pilote sync fails" do
      PiloteHelper.stub(:save_pilote_payment).and_return(false)
      set_pilote_correct_answer
      expect{
        manager.save_payment valid_payment, volunteer
      }.to change{ Payment.count }.by(0)
    end

    it "should add a sync error to payment if pilote sync fails" do
      PiloteHelper.stub(:save_pilote_payment).and_return(false)
      set_pilote_correct_answer
      manager.save_payment valid_payment, volunteer
      valid_payment.errors[:base].should include("Ha ocurrido un error al sincronizar el pago con Pilote")
    end

    it "should not register a payment in pilote if payment is invalid" do
      set_pilote_correct_answer
      PiloteHelper.should_not_receive(:save_pilote_payment)

      manager.save_payment invalid_payment, volunteer
    end

    private
    def setup_pilote_payment_sync(payment_type)
      set_pilote_correct_answer
      comment = "#{payment_type} - #{volunteer.full_name}"
      date = valid_payment.date.to_date.to_formatted_s(:db)
      return {"familia"=>valid_payment.family_id.to_s, "cantidad"=>valid_payment.amount.to_s, "fecha"=>date, "voucher"=>valid_payment.voucher, "comentario"=>comment }
    end
  end

  private
  def set_pilote_correct_answer
    pilote_response = [{"id_de_familia"=>56602,"jefe_de_familia"=>"Maria Rosario Fernandez Duchitanga","monto_original"=>120.00,"asentamiento"=>"Collana","ciudad"=>"Ludo, Sigsig","provincia"=>"Azuay","pagos"=>60.00}]
    PiloteHelper.stub(:get_families_details).and_return(pilote_response)
  end

end
