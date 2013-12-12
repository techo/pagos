# encoding: utf-8
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  ROLES = %w[volunteer administrator]

  validates :role, inclusion: { in: ROLES, message: 'No es un rol válido' }, allow_nil: true
  validates :first_name, presence: { message: "El campo Nombre es mandatorio" }
  validates :last_name, presence: { message: "El campo Apellido es mandatorio" }
  validates :password, presence: { message: "El campo Contraseña es mandatorio" },
                       confirmation: { message: "Las contraseñas no coinciden"},
                       length: { minimum: 10, message: 'El campo Contraseña debe tener al menos 10 caracteres de longitud', if: "password.present?"}
  validates :email, presence: { message: 'El campo Correo electrónico es mandatorio' },
                    uniqueness: { case_insensitive: true, message: 'El Correo electrónico ingresado ya está registrado' },
                    format: { with: Devise.email_regexp, message: "Debe ingresar una dirección de correo válida", if: "email.present?" }
end
