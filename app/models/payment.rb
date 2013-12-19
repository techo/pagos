class Payment < ActiveRecord::Base
  validates :family_id, presence: {message: "El campo FamilyId es mandatorio"}
  validates :amount, presence: {message: "El monto es mandatorio"}
  validates :date, presence: {message: "La fecha es mandatoria"}

end
