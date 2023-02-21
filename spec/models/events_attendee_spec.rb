RSpec.describe EventsAttendee, type: :model do
  let(:event) { create(:event) }
  let(:attendee) { create(:attendee) }
  subject { build(:events_attendee, event: event, attendee: attendee) }

  # Test associations
  it { should belong_to(:attendee) }
  it { should belong_to(:event) }

  # Test validations
  it { should validate_presence_of(:rsvp) }
end