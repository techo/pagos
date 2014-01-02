require 'spec_helper'

describe Assignment do
  it { should validate_presence_of(:geography) }
  it { should validate_presence_of(:volunteer) }
  it { should belong_to(:geography)  }
  it { should belong_to(:volunteer)  }
end
