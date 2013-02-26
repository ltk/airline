FactoryGirl.define do
  factory :invitation do
    company :factory => :company
    email "john.smith@example.com"
  end
end
