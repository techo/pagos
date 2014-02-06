class PaymentsController < ApplicationController
  before_action :verify_can_manage_payments

  def index
    @families = PiloteHelper.get_families [current_user]
    if ( @families.has_key?(:error) )
      @families = {}
      flash[:error] = "No se pudo conectar con Pilote"
    end
  end

  def create
    @payment = Payment.new(payment_params, debt: 0)
    @volunteer = current_user.becomes(Volunteer)
    manager = PaymentsManager.new

    if manager.save_payment(@payment, @volunteer)
      redirect_to payments_path, flash: { success: "El pago de $#{@payment.amount} de #{params["payment"]["family_name"]} ha sido registrado exitosamente!" }
    else
      @families = PiloteHelper.get_families [current_user]
      render action: "index"
    end
  end

  private
  def payment_params
    params[:payment][:deposit_number] = nil if params[:payment][:deposit_number] == ""
    params.require(:payment).permit(:family_id, :voucher, :amount, :deposit_number, :date)
  end
  def verify_can_manage_payments
    redirect_to root_url unless current_user && current_user.can_manage_payments?
  end
end
