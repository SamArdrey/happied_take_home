FactoryBot.define do
  factory :event do
    name { Faker::Lorem.words(number: 3).join(' ') }
    start_time { Faker::Time.between(from: DateTime.now, to: DateTime.now + 1.week) }
    end_time { Faker::Time.between(from: start_time, to: start_time + 3.hours) }
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    event_type { ['conference', 'meeting', 'webinar'].sample }
  end
end
