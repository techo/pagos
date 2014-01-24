class PaymentsManager

  def self.calculating_debt ( family )
    family_id = family["id_de_familia"].to_i
    charge = family["monto_original"].to_f
    pilote_payments = family["pagos"].to_f

    localPayments = Payment.where(:family_id => family_id)
    currentPayments = 0

    if ( localPayments.count > 0 )
      currentPayments = localPayments.sum(:amount)
    else
      Payment.create(family_id:family_id, amount:pilote_payments, voucher:"pilote", date: Date.today - 1 )
      currentPayments = pilote_payments
    end

    if ( charge >= currentPayments )
      charge - currentPayments
    else
      -1
    end
  end

  def save_payment(payment, volunteer)
    if payment.valid?
      payment.volunteer = volunteer
      payment.debt = calculate_debt payment.family_id
      payment.save
      return true
    end
    false
  end

  private

  def calculate_debt family_id
    last_payment = Payment.where(family_id: family_id).order(:date).last

    if last_payment
      last_payment.debt
    else
      family = PiloteHelper.get_families_details([family_id]).first
      family["monto_original"].to_f - family["pagos"].to_f
    end
  end
end
