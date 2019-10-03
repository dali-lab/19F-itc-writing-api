FactoryBot.define do
  factory :user do
    netid { "0000000" }
    name { "Test User" }
    firstname { "Test" }
    lastname { "User" }
    email { "test@test.com" }
  end
end
