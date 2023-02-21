class Event < ApplicationRecord
  has_many :events_attendees, dependent: :destroy
  has_many :attendees, through: :events_attendees

  validates_presence_of :name
  validates_presence_of :start_time
  validates_presence_of :end_time
  validates_presence_of :description
  validates_presence_of :event_type
end
