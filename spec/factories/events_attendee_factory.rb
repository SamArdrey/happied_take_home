FactoryBot.define do
  factory :events_attendee do
    association :event, required: true
    association :attendee, required: true
    rsvp { true }
  end
end
