class Attendee < ApplicationRecord
  has_many :events_attendees, dependent: :destroy
  has_many :events, through: :events_attendees

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
