require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    context "with invalid credentials" do
      it "displays an error message" do
        post :create
        request.flash[:error].should == "Couldn't locate a user with those credentials"
      end
    end
  end
end
