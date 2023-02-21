RSpec.describe Api::AttendeesController, type: :controller do
  describe 'GET #index' do
    let!(:attendee1) { create(:attendee) }
    let!(:attendee2) { create(:attendee) }

    it 'returns a success response' do
      get :index, format: :json
      expect(assigns(:attendees)).to match_array([attendee1, attendee2])
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:attendee) { create(:attendee) }
    let(:event) { create(:event) }
    let!(:events_attendee) { create(:events_attendee, attendee: attendee, event: event )}

    it 'returns a success response' do
      get :show, params: { id: attendee.id }, format: :json
      expect(response).to be_successful
      expect(response.body).to eq attendee.to_json(include: { events_attendees: { include: :event } })
    end
  end

  describe 'POST #create' do
    let(:attendee_params) { { name: 'Test Attendee', email: 'test@example.com' } }

    context 'with valid attendee parameters and valid event reservation parameters' do
      let(:event) { create(:event) }
      let(:reservation_params) { { event_id: event.id, rsvp: true } }
      let(:valid_params) { attendee_params.merge(reservation_params) }

      it 'creates a new attendee and returns a 201 status code' do
        post :create, params: { attendee: valid_params }
        expect(response).to have_http_status(:created)

        expect(Attendee.count).to eq(1)
        attendee = Attendee.last
        expect(attendee.name).to eq('Test Attendee')
        expect(attendee.email).to eq('test@example.com')

        expect(EventsAttendee.count).to eq(1)
        reservation = EventsAttendee.last
        expect(reservation.event_id).to eq(event.id)
        expect(reservation.attendee_id).to eq(attendee.id)
        expect(reservation.rsvp).to eq(true)
        expect(response.body).to eq(Attendee.last.to_json)
      end
    end

    context 'with invalid attendee parameters' do
      let(:invalid_params) { attendee_params.merge(email: '') }

      it 'does not create a new attendee and returns an unprocessable entity status code' do
        post :create, params: { attendee: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)

        expect(Attendee.count).to eq(0)
        expect(EventsAttendee.count).to eq(0)
        post :create, params: { attendee: invalid_params }
        expect(response.body).to eq(Attendee.new(invalid_params).tap(&:validate).errors.to_json)
      end
    end

    context 'with invalid event reservation parameters' do
      let(:event) { create(:event) }
      let(:reservation_params) { { event_id: event.id } }
      let(:invalid_params) { attendee_params.merge(reservation_params) }

      it 'does not create a new attendee and returns an unprocessable entity status code' do
        post :create, params: { attendee: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)

        expect(Attendee.count).to eq(1)
        expect(EventsAttendee.count).to eq(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "#update" do
    let(:attendee) { create(:attendee) }

    context "when attendee update succeeds and event reservation update succeeds" do
      before do
        put :update, params: { id: attendee.id }
        expect(response).to be_successful
        expect(response.body).to eq(attendee.to_json)
      end
    end

    context "when attendee update fails or event reservation update fails" do
      before do
        put :update, params: { id: attendee.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq(attendee.errors.to_json)
      end
    end
  end
end
