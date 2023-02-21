# frozen_string_literal: true

module Api
  class EventsController < ApplicationController
    before_action :set_event, only: [:update, :destroy]

    def index
      @events = Event.all
      render json: @events
    end

    def show
      event = Event.includes(events_attendees: :attendee).find(params[:id])
      render json: event.to_json(include: { events_attendees: { include: :attendee } })
    end

    def create
      @event = Event.new(event_params)

      if @event.save
        render json: @event, status: :created
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end

    def update
      if @event.update(event_params)
        render json: @event
      else
        render json: @event.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @event.destroy
      head :no_content
    end

    private

    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :start_time, :end_time, :description, :event_type)
    end
  end
end
