FactoryGirl.define do
  factory :user do
    company
    first_name "John"
    last_name "Smith"
    sequence(:email) { |i| "email-#{i}@example.com" }
    password "password"
    password_confirmation "password"
    avatar { fixture_file_upload(Rails.root.join('spec','fixtures','images','example.png'), 'image/png') }
  end
end
