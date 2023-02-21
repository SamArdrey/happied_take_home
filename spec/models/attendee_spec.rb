RSpec.describe Attendee, type: :model do
  subject { build(:attendee) }

  # Test associations
  it { should have_many(:events_attendees).dependent(:destroy) }
  it { should have_many(:events).through(:events_attendees) }

  # Test validations
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:email) }
end
