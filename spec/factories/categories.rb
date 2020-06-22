FactoryBot.define do
  factory :category do
    association :user
    name {Faker::Book.title}

    trait :with_referrer do
      association :referrer, factory: :category
    end
  end
end
