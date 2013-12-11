require 'spec_helper'

describe FormHelper do
  include Devise::TestHelpers

  describe ".form_error_messages" do
    it "creates a list of error messages" do
      user = User.new
      user.stub(:errors).and_return(double(messages: {field: ["this is a really bad error"]},
                                           empty?: false))
      helper.stub(:resource).and_return(user)

      helper.form_error_messages.should match /<li>this is a really bad error<\/li>/
    end
  end
end
