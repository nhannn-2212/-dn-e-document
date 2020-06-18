FactoryBot.define do
  factory :user do
    sequence(:email){Faker::Internet.email}
    fullname {Faker::Name.name}
    password {"foobar"}
    password_confirmation {"foobar"}
  end
end
