require 'spec_helper'

describe UsersController do
  describe "#update" do
    let(:user) { create(:user, :company => create(:company)) }
    before { session[:user_id] = user.id }

    it "does not allow company_id updates" do
      expect {
        put :update, :user => { :company_id => 2 }
      }.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
