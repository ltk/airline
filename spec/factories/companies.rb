FactoryGirl.define do
  factory :company do
    sequence(:name) { |i| "Acme #{i}, Inc." }
  end
end
