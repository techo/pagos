# encoding: UTF-8

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

    it "should accept a form resource as an optional parameter" do 
      user = User.new
      user.stub(:errors).and_return(double(messages: {field: ["this is a really bad error"]},
                                           empty?: false))
      helper.stub(:resource).and_return(nil)

      helper.form_error_messages(user).should match /<li>this is a really bad error<\/li>/
    end
  end

  describe ".encode_utf_8" do
    it "should returns año encoded for a\u00c3\u00b1o" do
      original_text = "a\u00c3\u00b1o"
      text = helper.encode_utf_8 original_text
      text.should == "año"
    end

    it "should returns áó encoded for a\u00c3\u00b1o" do
      original_text = "\u00c3\u00a1\u00c3\u00b3"
      text = helper.encode_utf_8 original_text
      text.should == "áó"
    end

    it "should returns nil for nil" do
      text = helper.encode_utf_8 nil
      text.should == nil
    end
  end
end
