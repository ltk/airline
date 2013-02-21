require 'spec_helper'

describe UsersController do
  describe "POST 'create'" do
    before do
      @user_attributes = FactoryGirl.attributes_for(:user)
    end

    it "should create a new user" do
      expect {
        post :create, :user => @user_attributes
      }.to change(User, :count).by(1)
    end
  end
end
