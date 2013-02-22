FactoryGirl.define do
  factory :user do
    company FactoryGirl.create(:company)
    first_name "John"
    last_name "Smith"
    email "john.smith@example.com"
    password "password"
    password_confirmation "password"
  end
end
