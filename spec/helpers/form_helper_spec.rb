require 'spec_helper'

describe FormHelper do
  describe ".devise_error_messages!" do
    xit "creates a list of error messages" do
      Object.any_instance.stub(:errors).and_return(messages: {field: "this is a really bad error"})

      devise_error_messages!.should match /<li>this is a really bad error<\/li>/
    end
  end
end
