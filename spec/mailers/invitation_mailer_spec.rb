require 'spec_helper'

describe InvitationMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe ".invite" do
    let(:invitation) { FactoryGirl.create(:invitation) }
    subject { InvitationMailer.invite(invitation) }
    
    it { should deliver_to invitation.email }

    it "has the correct subject" do
      should have_subject "Invitation to Airline"
    end

    it "contains a signup link" do
      should have_body_text "#{default_url_options[:host]}/user/new?code=#{invitation.code}"
    end

    it "contains the company name" do
      should have_body_text "Acme, Inc."
    end
  end
end
