class RemoveRsvpFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :attendees, :rsvp, :boolean
  end
end
