FactoryBot.define do
  factory :comment do
    association :user
    association :document
    content {Faker::Lorem.paragraph}
  end
end
