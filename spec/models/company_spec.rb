require 'spec_helper'

describe Company do
  subject{ create(:company) }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:slug) }

    it "does not allow duplicate slugs" do
      new_company = create(:company)
      expect{ new_company.update_attributes(:slug => subject.slug) }.to raise_error
    end
  end

  context 'associations' do
    it { should have_many(:invitations) }
    it { should have_many(:users) }
    it { should have_many(:images) }
  end

  describe '#before_validation' do
    let(:company) { build(:company, :name => "Viget Labs") }
    it 'sets a slug' do
      company.save
      company.slug.should == "viget-labs"
    end
  end
end
