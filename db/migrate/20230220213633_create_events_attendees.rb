class CreateEventsAttendees < ActiveRecord::Migration[7.0]
  def change
    create_table :events_attendees do |t|
      t.references :attendee, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.boolean :rsvp, null: false

      t.timestamps
    end
  end
end
