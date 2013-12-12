# encoding: utf-8
require 'spec_helper'

describe User do

  describe 'validations' do

    EMAIL_FORMAT_ERROR_MSG = 'Debe ingresar una dirección de correo válida'
    PASSWORD_LENGTH_ERROR_MSG = 'El campo Contraseña debe tener al menos 10 caracteres de longitud'

    it { should validate_presence_of(:first_name).with_message('El campo Nombre es mandatorio') }
    it { should validate_presence_of(:last_name).with_message('El campo Apellido es mandatorio') }
    it { should validate_presence_of(:email).with_message('El campo Correo electrónico es mandatorio') }
    it { should validate_uniqueness_of(:email).case_insensitive.with_message('El Correo electrónico ingresado ya está registrado') }
    it { should validate_presence_of(:password).with_message('El campo Contraseña es mandatorio') }
    it { should ensure_length_of(:password).is_at_least(10).with_message(PASSWORD_LENGTH_ERROR_MSG) }
    it { should validate_confirmation_of(:password).with_message('Las contraseñas no coinciden') }
    it { should_not allow_value('test@test').for(:email).with_message(EMAIL_FORMAT_ERROR_MSG) }
    it { should_not allow_value('fake_role').for(:role).with_message('No es un rol válido') }
    it { should allow_value('volunteer').for(:role) }
    it { should allow_value('administrator').for(:role) }
    it { should allow_value(nil).for(:role) }

    it 'should not validate email format if email is not present' do
      user = User.new
      user.valid?
      user.errors.messages[:email].should_not include EMAIL_FORMAT_ERROR_MSG
    end

    it 'should not validate password length if password is not present' do
      user = User.new
      user.valid?
      user.errors.messages[:password].should_not include PASSWORD_LENGTH_ERROR_MSG
    end
  end
end

