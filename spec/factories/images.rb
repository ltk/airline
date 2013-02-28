FactoryGirl.define do
  factory :image do
    user
    company
    file { fixture_file_upload(Rails.root.join('spec','fixtures','images','example.png'), 'image/png') }
  end
end
