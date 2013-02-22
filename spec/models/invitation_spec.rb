require 'spec_helper'

describe Invitation do
  context 'validations' do
    before do
      FactoryGirl.create(:invitation)
    end

    it { should belong_to(:company) }
    it { should validate_presence_of(:email) }
    it { should_not allow_value("not_an_email").for(:email) }
    it { should_not allow_value("not@an-email").for(:email) }
    it { should allow_value("is@an-email.com").for(:email) }
  end
end
