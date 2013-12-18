class PaymentsController < ApplicationController

  def new
    @payment = Payment.new
    @family_id = params[:family_id]
  end

  def create
    payment = Payment.new(payment_params)
    if payment.save
      redirect_to root_path
    else
      render action: "new"
    end
  end

  def payment_params
    params.require(:payment).permit(:family_id, :amount, :date)
  end
end
