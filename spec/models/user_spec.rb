require 'spec_helper'

describe User do
  context 'validations' do
    before { create(:user) }

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:slug) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:company) }
    it { should validate_uniqueness_of(:email) }
    it { should_not allow_value("not_an_email").for(:email) }
    it { should_not allow_value("not@an-email").for(:email) }
    it { should allow_value("is@an-email.com").for(:email) }
    it { should_not allow_value("1234").for(:password) }
    it { should allow_value("12345").for(:password) }

    it "does not allow duplicate slugs" do
      new_user = create(:user)
      expect{ new_user.update_attributes(:slug => user.slug) }.to raise_error
    end
  end

  context 'mass assignment' do
    it { should allow_mass_assignment_of(:first_name) }
    it { should allow_mass_assignment_of(:last_name) }
    it { should allow_mass_assignment_of(:email) }
    it { should allow_mass_assignment_of(:password) }
    it { should allow_mass_assignment_of(:password_confirmation) }
    it { should allow_mass_assignment_of(:avatar) }
    it { should allow_mass_assignment_of(:company_id) }
    it { should allow_mass_assignment_of(:company_attributes) }
    it { should_not allow_mass_assignment_of(:company_id).as(:update) }
    it { should_not allow_mass_assignment_of(:company_attributes).as(:update) }
  end

  context 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:images) }
  end

  context "after save" do
    let(:user) { create(:user, :password_reset_token => "1234") }
    before do
      user.update_attributes(:password => "new-password", :password_confirmation => "new-password")
    end

    context "when setting a password reset token" do
      before do
        user.update_attributes(:password_reset_token => "new-reset-token")
      end

      it "does not unset the password reset token" do
        user.password_reset_token.should_not be_nil
      end
    end

    context "when not setting a password reset token" do
      before do
        user.update_attributes(:password => "new-password", :password_confirmation => "new-password")
      end

      it "unsets the password reset token" do
        user.password_reset_token.should be_nil
      end
    end
  end

  describe ".new_from_invite_code" do
    let(:invite) { create(:invitation) }
    let(:user) { User.new_from_invite_code(invite.code) }

    it "returns a User with an email address" do
      user.email.should_not be_blank
    end

    it "returns a User with a company association" do
      user.company_id.should_not be_blank
    end
  end

  describe "#send_password_reset_instructions" do
    let(:user) { create(:user) }

    it "set a new password_reset_token" do
      SecureRandom.should_receive(:urlsafe_base64).with(20).and_return('code')
      user.send_password_reset_instructions

      user.password_reset_token.should == 'code'
    end

    it "sends an PasswordResetMailer" do
      mail = double("mail")
      PasswordResetMailer.stub(:send_reset_instructions).and_return(mail)
      mail.should_receive(:deliver)
      user.send_password_reset_instructions
    end
  end

  describe "#full_name" do
    let(:user) { create(:user, :first_name => "First", :last_name => "Last") }

    it "returns the user's full name" do
      user.full_name.should eql("First Last")
    end
  end

  describe "#build_image" do
    let(:user) { create(:user) }
    let(:image) { user.build_image({ :file => "/some_directory/example.png" }) }

    it "returns an instance of Image" do
      image.should be_a(Image)
    end

    it "assigns itself as the image's user" do
      image.user.should eql(user)
    end

    it "assigns its company as the image's company" do
      image.company.should eql(user.company)
    end
  end

  describe "#coworker_of?" do
    let(:company) { create(:company) }
    let(:user) { create(:user, :company => company) }

    context "when passed a user in a different company" do
      let(:other_user) { create(:user, :company => create(:company)) }
      subject{ user.coworker_of?(other_user) }

      it { should be_false }
    end

    context "when passed a user in the same company" do
      let(:other_user) { create(:user, :company => company) }
      subject{ user.coworker_of?(other_user) }

      it { should be_true }
    end
  end

  describe "#authorized_for_company?" do
    let(:user) { create(:user) }

    context "when passed a different company" do
      let(:company) { create(:company) }
      subject{ user.authorized_for_company?(company) }

      it { should be_false }
    end

    context "when passed the user's company" do
      let(:company) { user.company }
      subject{ user.authorized_for_company?(company) }

      it { should be_true }
    end
  end
end
