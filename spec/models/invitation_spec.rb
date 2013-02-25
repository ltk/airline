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
      invitation.code.should =~ /[a-zA-Z0-9-_=]{12}/
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

      code = 'abcdef123456'
      SecureRandom.stub!(:urlsafe_base64).and_return(code)

      invitation = FactoryGirl.create(:invitation)
      invitation.code.should == code
    end
  end
end