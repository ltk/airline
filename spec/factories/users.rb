# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name "Smith"
    company_name "Acme, Inc."
    email "john.smith@example.com"
    password "password"
    password_confirmation "password"
  end
end
