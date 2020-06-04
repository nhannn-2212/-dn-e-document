User.create!(fullname: "Example User",
  email:
  "example@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: 2,
  active: true,
  coin: 0)
30.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!(fullname: name,
    email: email,
    password: password,
    password_confirmation: password,
    active: true,
    role: 1,
    coin: 0)
end
