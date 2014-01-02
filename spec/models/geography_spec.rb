require 'spec_helper'

describe Geography do
    it { should validate_presence_of(:village_id).with_message('El identificador de asentamiento es mandatorio') }
    it { should have_many(:volunteers)  }
    it { should validate_uniqueness_of(:village_id)}
end
