class PaymentsController < ApplicationController
  before_action :verify_can_manage_payments

  def index
    @families = PiloteHelper.get_families current_user
  end

  def create
    payment = Payment.new(payment_params)
    if payment.save
      redirect_to payments_path, flash: { success: "El pago ha sido registrado!" }
    else
      @families = PiloteHelper.get_families current_user
      @payment = payment
      render action: "index"
    end
  end

  private
  def payment_params
    params.require(:payment).permit(:family_id, :amount, :date)
  end

  def verify_can_manage_payments
    redirect_to root_url unless current_user && current_user.can_manage_payments?
  end
end
