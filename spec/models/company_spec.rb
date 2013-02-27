require 'spec_helper'

describe Company do
  context 'validations' do
    before do
      FactoryGirl.create(:company)
    end
    
    context 'validations' do
      it { should validate_presence_of(:name) }
    end

    context 'associations' do
      it { should have_many(:invitations) }
      it { should have_many(:users) }
      it { should have_many(:images) }
    end
  end
end
