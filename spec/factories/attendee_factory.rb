FactoryBot.define do
  factory :attendee do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
