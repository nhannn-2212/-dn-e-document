FactoryBot.define do
  factory :user do
    sequence(:email){Faker::Internet.email}
    fullname {Faker::Name.name}
    password {"foobar"}
    password_confirmation {"foobar"}
    coin {0}
    role {User.roles[:member]}

    trait :admin do
      role {User.roles[:admin]}
    end
  end
end
