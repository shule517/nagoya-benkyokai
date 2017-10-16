module Api
  module V1
    class EventsController < ApplicationController
      def index
        render json: events, each_serializer: EventsSerializer
      end

      def events
        Event.scheduled
      end
    end
  end
end
