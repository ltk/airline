require 'spec_helper'

describe Invitation do
  context 'validations' do
    it { should belong_to(:company) }
    it { should validate_presence_of(:email) }
    it { should_not allow_value("not_an_email").for(:email) }
    it { should_not allow_value("not@an-email").for(:email) }
    it { should allow_value("is@an-email.com").for(:email) }
  end

  describe "#set_invite_code" do
    context "when an invitation already has a code" do
      it "should not change the code" do
        invitation = FactoryGirl.create(:invitation)
        old_code = invitation.code
        invitation.send(:set_invite_code)

        invitation.code.should eql(old_code)
      end
    end

    context "when an invitation has no code" do
      it "should set the invitation code upon creation" do
        new_invitation = FactoryGirl.build(:invitation)
        new_invitation.save

        new_invitation.code.should_not be_blank
      end
    end
  end

  describe "#generate_code" do
    it "should execute callback upon creation" do
      invitation = FactoryGirl.build(:invitation)
      invitation.should_receive(:generate_code)
      invitation.save
    end

    it "should generate a hex hash code" do
      time_now = Time.parse("Jan 1 2013")
      Time.stub!(:now).and_return(time_now)

      code = 'abcdef1234567890'
      Digest::SHA1.stub!(:hexdigest).and_return('abcdef1234567890')

      invitation = FactoryGirl.create(:invitation)
      invitation.code.should == code
    end
  end

  describe "#send_invite_email" do
    it "should execute callback upon creation" do
      invitation = FactoryGirl.build(:invitation)
      invitation.should_receive(:send_invite_email)
      invitation.save
    end
  end
end