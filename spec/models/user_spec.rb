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
    it { should validate_presence_of(:password).on(:create).with_message('El campo Contraseña es mandatorio') }
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

  describe '#can_manage_users?' do
    it 'is true if the user is an administrator' do
      user = FactoryGirl.build(:administrator_user)
      user.can_manage_users?.should be_true
    end

    it 'is false if the user is a volunteer' do
      user = FactoryGirl.build(:volunteer_user)
      user.can_manage_users?.should be_false
    end
  end

  describe '#can_manage_payments?' do
    it 'is true if the user is a volunteer' do
      user = FactoryGirl.build(:volunteer_user)
      user.can_manage_payments?.should be_true
    end

    it 'is false if the user is a administrator' do
      user = FactoryGirl.build(:administrator_user)
      user.can_manage_payments?.should be_false
    end

  end
  
  describe '#volunteers' do
    let!(:volunteer_user) { FactoryGirl.build(:volunteer_user, first_name: "pedro") }
    let!(:volunteer_additional_user) { FactoryGirl.build(:volunteer_additional_user, first_name: "maria") }
    let!(:administrator_user) { FactoryGirl.build(:administrator_user, first_name: "juan") }

    it 'orders by ascending name' do
      volunteer_user.save
      administrator_user.save
      volunteer_additional_user.save
      User.volunteers.should == [volunteer_user, volunteer_additional_user]
    end

  end
end

