require "spec_helper"

describe Invitation do
  context "validations" do
    it { should belong_to(:company) }
    it { should validate_presence_of(:email) }
    it { should_not allow_value("not_an_email").for(:email) }
    it { should_not allow_value("not@an-email").for(:email) }
    it { should allow_value("is@an-email.com").for(:email) }
  end

  context "before create" do
    let(:invitation) { FactoryGirl.build(:invitation) }

    it "sets a code on the record" do
      SecureRandom.should_receive(:urlsafe_base64).with(12).and_return('code')
      invitation.save

      invitation.code.should == 'code'
    end

    it "choose a new code when choosing a duplicate" do
      SecureRandom.should_receive(:urlsafe_base64).with(12).exactly(3).times.and_return("code", "code", "new_code")
      described_class.create(:email => "user@host.com", :company_id => 1)
      invitation.save
    end
  end

  context "after create" do
    let(:invitation) { FactoryGirl.build(:invitation) }

    it "sends an InvitationMailer" do
      mail = double("mail", :deliver => nil)
      InvitationMailer.stub(:invite).and_return(mail)
      mail.should_receive(:deliver)
      invitation.save
    end
  end

  describe ".code_unique?" do
    subject { described_class.code_unique?('code') }

    context "when passed a non-unique code" do
      before do
        SecureRandom.stub(:urlsafe_base64).and_return('code')
        FactoryGirl.create(:invitation)
      end

      it { should be false }
    end

    context "when passed a unique code" do
      it { should be true }
    end
  end
end