describe ApplicationController do
  controller do
    after_filter :no_xhr_flashes

    def method
      render :nothing => true
    end
  end

  it "does not filter the nombre" do

  end

  xit "does not filter the appelido" do

  end
end
