require 'spec_helper'

describe PasswordResetMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe ".send_reset_instructions" do
    let(:user) { FactoryGirl.create(:user) }
    before { user.password_reset_token = '1234' }
    subject { PasswordResetMailer.send_reset_instructions(user) }
    
    it { should deliver_to user.email }

    it "has the correct subject" do
      should have_subject "Password Reset Instructions"
    end

    it "contains a reset link" do
      should have_body_text /\<a[^>]*href=['"]http:\/\/localhost:3000.*token=1234.*user_id=#{user.id}['"][^>]*>Click here to reset your password/
    end
  end
end