require 'spec_helper'

describe User do
  context 'validations' do
    before do
      FactoryGirl.create(:user)
    end

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should_not allow_value("not_an_email").for(:email) }
    it { should_not allow_value("not@an-email").for(:email) }
    it { should allow_value("is@an-email.com").for(:email) }
    it { should_not allow_value("1234").for(:password) }
    it { should allow_value("12345").for(:password) }
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

  describe ".new_from_invite_code" do
    let(:invite) { FactoryGirl.create(:invitation) }
    let(:user) { User.new_from_invite_code(invite.code) }

    it "returns a User with an email address" do
      user.email.should_not be_blank
    end

    it "returns a User with a company association" do
      user.company_id.should_not be_blank
    end
  end
end
