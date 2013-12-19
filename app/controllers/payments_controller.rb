class PaymentsController < ApplicationController

  def index
    @families = PiloteHelper.get_families
  end

  def create
    payment = Payment.new(payment_params)
    if payment.save
      redirect_to payments_path, flash: { success: "El pago ha sido registrado!" }
    else
      @families = PiloteHelper.get_families
      @payment = payment
      render action: "index"
    end
  end

  private
  def payment_params
    params.require(:payment).permit(:family_id, :amount, :date)
  end
end
