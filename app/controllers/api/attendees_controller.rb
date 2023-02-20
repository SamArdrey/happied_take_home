# frozen_string_literal: true

module Api
  class AttendeesController < ApplicationController
    before_action :set_attendee, only: [:show, :update, :destroy]

    def index
      @attendees = Attendee.all
      render json: @attendees
    end

    def show
      render json: @attendee
    end

    def create
      @attendee = Attendee.new(attendee_params)

      if @attendee.save
        render json: @attendee, status: :created
      else
        render json: @attendee.errors, status: :unprocessable_entity
      end
    end

    def update
      if @attendee.update(attendee_params)
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
      params.require(:attendee).permit(:name, :email, :rsvp)
    end
  end
end