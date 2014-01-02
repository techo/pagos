require 'spec_helper'

describe Assignment do
  it { should validate_presence_of(:geography) }
  it { should validate_presence_of(:volunteer) }
  it { should belong_to(:geography)  }
  it { should belong_to(:volunteer)  }
  it { should validate_uniqueness_of(:geography_id).scoped_to(:volunteer_id)}
  it { should validate_uniqueness_of(:volunteer_id).scoped_to(:geography_id)}
end
