# frozen_string_literal: true

module Api
  class AttendeesController < ApplicationController
    before_action :set_attendee, only: [:update, :destroy]

    def index
      @attendees = Attendee.all
      render json: @attendees
    end

    def show
      attendee = Attendee.includes(events_attendees: :event).find(params[:id])
      render json: attendee.to_json(include: { events_attendees: { include: :event } })
    end

    def create
      @attendee = Attendee.new(attendee_params)

      if @attendee.save && successful_event_reservation?
        render json: @attendee, status: :created
      else
        render json: @attendee.errors, status: :unprocessable_entity
      end
    end

    def update
      if @attendee.update(attendee_params) && update_event_reserveation?
        render json: @attendee
      else
        render json: @attendee.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @attendee.destroy
      head :no_content
    end

    private

    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    def attendee_params
      params.require(:attendee).permit(:name, :email).except(:rsvp, :event_id)
    end

    def event_id
      params[:attendee][:event_id]
    end

    def rsvp
      params[:attendee][:rsvp]
    end

    def successful_event_reservation?
      return true if !event_id.present? && !rsvp.present?
      return false if !event_id.present? || !rsvp.present?
      EventsAttendee.create!(attendee_id: @attendee.id, event_id: event_id, rsvp: rsvp)
    end

    def update_event_reserveation?
      return true if !event_id.present? && rsvp.present?
      return false if !event_id.present? || !rsvp.present?
      event = EventsAttendee.find_by(event_id: event_id, attendee_id: params[:attendee_id])
      return event.update!(rsvp: rsvp) if event.present?
      EventsAttendee.create!(attendee_id: @attendee.id, event_id: event_id, rsvp: rsvp)
    end
  end
end
