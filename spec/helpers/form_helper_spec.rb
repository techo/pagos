require 'spec_helper'

describe FormHelper do
  describe ".form_error_messages" do
    it "creates a list of error messages" do
      user = User.new
      user.stub(:errors).and_return(double(messages: {field: ["this is a really bad error"]},
                                           empty?: false))
      helper.stub(:resource).and_return(user)

      helper.form_error_messages.should match /<li>this is a really bad error<\/li>/
    end

    it "should not include only one error message" do
      user = User.new
      user.stub(:errors).and_return(double(messages: {field: ["this is a really bad error"], field1: []},
                                           empty?: false))
      helper.stub(:resource).and_return(user)

      helper.form_error_messages.scan("<li>").size.should == 1
    end

    it "should accept a form resource as an optional parameter" do 
      user = User.new
      user.stub(:errors).and_return(double(messages: {field: ["this is a really bad error"]},
                                           empty?: false))
      helper.stub(:resource).and_return(nil)

      helper.form_error_messages(user).should match /<li>this is a really bad error<\/li>/
    end
  end
end
