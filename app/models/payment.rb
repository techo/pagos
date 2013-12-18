class Payment < ActiveRecord::Base
  validates :family_id, presence: {message: "El campo FamilyId es mandatorio"}
  validates :amount, presence: {message: "El campo Amount es mandatorio"}
  validates :date, presence: {message: "El campo Date es mandatorio"}

end
