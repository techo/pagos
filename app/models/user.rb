class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :first_name, presence: { message: "El campo Nombre es requerido" }
  validates :last_name, presence: { message: "El campo Apellido es requerido" }
end
