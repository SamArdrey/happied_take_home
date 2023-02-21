class EventsAttendee < ApplicationRecord
  belongs_to :event
  belongs_to :attendee

  validates_presence_of :rsvp
end
