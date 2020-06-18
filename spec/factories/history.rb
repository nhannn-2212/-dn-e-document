FactoryBot.define do
  factory :history do
    association :user
    association :document
  end
end
