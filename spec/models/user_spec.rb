require 'spec_helper'

describe User do

  describe 'validations' do
    it { should validate_presence_of(:first_name).with_message('El campo Nombre es requerido') }
    it { should validate_presence_of(:last_name).with_message('El campo Apellido es requerido') }
  end

end

