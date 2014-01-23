module Validators
  class PaymentValidator < ActiveModel::Validator

    def validate(payment)
      payment.errors.add(:voucher, "El voucher es mandatorio") if
      (!payment.amount.nil? && payment.amount > 0) && (payment.voucher.nil? || payment.voucher.empty?)
    end

  end
end
