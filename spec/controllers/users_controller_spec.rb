require 'spec_helper'

describe UsersController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user_attributes = FactoryGirl.attributes_for(:user)
    end

    it "should create a new user" do
      expect {
        post :create, :user => @user_attributes
      }.to change(User, :count).by(1)
    end

    it "returns http success" do
      get 'create'
      response.should be_success
    end
  end

end
