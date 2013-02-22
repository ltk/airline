require 'spec_helper'

describe Company do
  context 'validations' do
    before do
      FactoryGirl.create(:company)
    end

    it { should have_many(:invitations) }
    it { should have_many(:users) }
    it { should validate_presence_of(:name) }
  end
end
