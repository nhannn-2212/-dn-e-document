FactoryBot.define do
  factory :favorite do
    association :user
    association :document
  end
end
