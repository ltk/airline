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

    it "receives #set_invite_code" do
      invitation.should_receive(:set_invite_code)
      invitation.save
    end

    it "sets a code on the record" do
      invitation.save
      invitation.code.should =~ /[a-f0-9]{40}/
    end
  end

  context "after create" do
    let(:invitation) { FactoryGirl.build(:invitation) }

    it "receives #send_invite_email" do
      invitation.should_receive(:send_invite_email)
      invitation.save
    end
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
      it "sets the invitation code upon creation" do
        new_invitation = FactoryGirl.build(:invitation)
        new_invitation.save

        new_invitation.code.should_not be_blank
      end
    end
  end

  describe "#generate_code" do
    it "generates a hex hash code" do
      time_now = Time.parse("Jan 1 2013")
      Time.stub!(:now).and_return(time_now)

      code = 'abcdef1234567890'
      Digest::SHA1.stub!(:hexdigest).and_return('abcdef1234567890')

      invitation = FactoryGirl.create(:invitation)
      invitation.code.should == code
    end
  end
end