# encoding: utf-8

class Payment < ActiveRecord::Base
  validates :family_id, presence: {message: "El campo FamilyId es mandatorio"}
  validates :amount, presence: {message: "El monto es mandatorio"}, 
                     numericality: {greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 10000,
                                    message: "El monto debe ser numérico entre 0 y 10000"}
  validates :date, presence: {message: "La fecha es mandatoria"}
end
