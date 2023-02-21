RSpec.describe Api::EventsController, type: :controller do
  describe 'GET #index' do
    it 'returns all events' do
      event1 = create(:event)
      event2 = create(:event)
      get :index
      expect(assigns(:events)).to match_array([event1, event2])
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:event) { create(:event) }

    it 'returns the requested event with its attendees' do
      attendee1 = create(:attendee)
      attendee2 = create(:attendee)
      create(:events_attendee, attendee: attendee1, event: event)
      create(:events_attendee, attendee: attendee2, event: event)

      get :show, params: { id: event.id }
      response_body = JSON.parse(response.body)
      expect(response_body['id']).to eq(event.id)
      expect(response_body['name']).to eq(event.name)
      expect(response_body['events_attendees'].length).to eq(2)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          event: {
            name: 'Example Event',
            start_time: Time.now,
            end_time: Time.now + 1.hour,
            description: 'An example event',
            event_type: 'example'
          }
        }
      end

      it 'creates a new event' do
        expect {
          post :create, params: valid_params
        }.to change(Event, :count).by(1)
        expect(response).to have_http_status(201)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          event: {
            name: '',
            start_time: Time.now,
            end_time: Time.now + 1.hour,
            description: 'An example event',
            event_type: 'example'
          }
        }
      end

      it 'does not create a new event' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Event, :count)
        expect(response).to have_http_status(422)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to include({ "name": ["can't be blank"] }.to_json)
      end
    end
  end

  describe "PATCH #update" do
    let!(:event) { create(:event) }
    let(:invalid_attributes) { attributes_for(:event, name: nil) }

    context "with valid params" do
      before do
        patch :update, params: { id: event.id, event: { name: 'new name' } }
        event.reload
      end

      it "updates the requested event" do
        expect(event.name).to eq('new name')
        expect(response).to be_successful
      end
    end

    context "with invalid params" do
      before do
        patch :update, params: { id: event.id, event: invalid_attributes }
        event.reload
      end

      it "returns an error response" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(event.name).not_to eq(invalid_attributes[:name])
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:event) { FactoryBot.create(:event) }
    context 'when event exists' do
      it 'deletes the event' do
        expect {
          delete :destroy, params: { id: event.id }
        }.to change(Event, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

    context 'when event does not exist' do
      it 'raises an error' do
        expect do
          delete :destroy, params: { id: 9999 }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
