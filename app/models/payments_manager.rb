class PaymentsManager

  def save_payment(payment, volunteer)
    calculate_current_debt payment
    payment.volunteer = volunteer
    if payment.valid?

       saved = save_pilote(payment) if payment.amount > 0
       if ( saved || payment.amount == 0 )
         saved = payment.save
       else
         payment.errors.add(:base, "Ha ocurrido un error al sincronizar el pago con Pilote")
       end
      return saved
    end
    false
  end

  private
  def get_last_family_debt family_id
    last_payment = Payment.last_family_payment family_id
    if last_payment
      last_payment.debt || 0
    else
      family = PiloteHelper.get_families_details([family_id]).first
      family["monto_original"].to_f - family["pagos"].to_f
    end
  end

  def calculate_current_debt payment
    payment.debt = get_last_family_debt(payment.family_id) - payment.amount unless payment.amount.nil?
  end

  def save_pilote(payment)
    comment = payment.short_description
    date = payment.date.to_date.to_formatted_s(:db)
    pilote_payment = {"familia"=>payment.family_id.to_s, "cantidad"=>payment.amount.to_s, "fecha"=>date, "voucher"=>payment.voucher, "comentario"=>comment }
    PiloteHelper.save_pilote_payment pilote_payment
  end


end
