class PaymentsManager
  def self.calculating_debt ( charge, pilote_payments )
    charge = charge.to_f
    pilote_payments = pilote_payments.to_f
    if ( charge > pilote_payments )
      charge - pilote_payments
    else
      -1
    end
  end
end
