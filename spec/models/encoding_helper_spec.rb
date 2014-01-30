# encoding: UTF-8

require 'spec_helper'
describe "EncodingHelper" do
  describe ".encode_utf_8" do
    it "should returns año encoded for a\u00c3\u00b1o" do
      original_text = "a\u00c3\u00b1o"
      text = EncodingHelper.encode_utf_8 original_text
      text.should == "año"
    end

    it "should returns áó encoded for a\u00c3\u00b1o" do
      original_text = "\u00c3\u00a1\u00c3\u00b3"
      text = EncodingHelper.encode_utf_8 original_text
      text.should == "áó"
    end

    it "should returns nil for nil" do
      text = EncodingHelper.encode_utf_8 nil
      text.should == nil
    end
  end
end
