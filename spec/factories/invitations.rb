FactoryGirl.define do
  factory :invitation do
    company FactoryGirl.create(:company)
    email "john.smith@example.com"
  end
end
