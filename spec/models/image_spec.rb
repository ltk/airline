require "spec_helper"

describe Image do
  context "validation" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:file) }
  end

  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:company) }
  end
end
