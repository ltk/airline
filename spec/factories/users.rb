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

  factory :user_with_images, :parent => :user do
    ignore do
      images_count 3
    end

    after(:create) do |user, evaluator|
      FactoryGirl.create_list(:image, evaluator.images_count, :user => user, :company => user.company)
    end
  end

  factory :user_without_avatar, :parent => :user_with_images do
    before(:create) do |user|
      user.remove_avatar!
    end
  end
end
