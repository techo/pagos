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
      Payment.create(family_id:family_id, amount:pilote_payments, date: Date.today - 1 )
      currentPayments = pilote_payments
    end

    if ( charge >= currentPayments )
      charge - currentPayments
    else
      -1
    end
  end

end
