module Api
  module V1
    class EventsController < ApplicationController
      def index
        render json: events, each_serializer: EventsSerializer
      end

      def events
        Event.scheduled.each do |event|
          event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
        end
      end
    end
  end
end
