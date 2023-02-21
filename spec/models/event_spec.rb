RSpec.describe Event, type: :model do
  subject { build(:event) }

  # Test associations
  it { should have_many(:events_attendees).dependent(:destroy) }
  it { should have_many(:attendees).through(:events_attendees) }

  # Test validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:event_type) }
end
