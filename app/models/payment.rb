# encoding: utf-8

class Payment < ActiveRecord::Base


  validates :family_id, presence: {message: "El campo FamilyId es mandatorio"}
  validates :amount, presence: {message: "El monto es mandatorio"}, 
                     numericality: {greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 10000,
                                    message: "El monto debe ser numérico entre 0 y 10000"}
  validates :date, presence: {message: "La fecha es mandatoria"}
  validates :deposit_number, length: {maximum: 50, message: "El número de depósito es demasiado largo"}
  validates :deposit_number, length: {minimum: 4, allow_nil:true, message: "El número de depósito es demasiado corto"}
  validates :debt, numericality: {greater_than_or_equal_to: 0, message: "El monto pagado no puede ser mayor a la deuda"}

  validates_with Validators::PaymentValidator, fields: [:voucher]

  belongs_to :volunteer

  scope :has_volunteer, -> { Payment.joins(:volunteer).includes(:volunteer)}

  def self.last_family_payment(family_id)
    Payment.where(:family_id => family_id).order(:date).last
  end

  def self.within_range(from, to)
    self.where(Date: from.beginning_of_day..to.end_of_day ).order(:date)
  end

  def type
    return "EFECTIVO" if amount>0 && deposit_number.nil?
    return "COMPROBANTE" if deposit_number
    return "VISITA" if amount == 0
  end
end
