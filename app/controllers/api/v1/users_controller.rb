module Api
  module V1
    class UsersController < ApplicationController
      def show
        @user = User.find_by(twitter_id: params[:userid])
        participants = Participant.where(user_id: @user.id)
        event_ids = participants.map(&:event_id)
        users_events = Event.where('id in (?)', event_ids)
        @events = users_events.order(:started_at).each do |event|
          event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
        end
        render json: @events
      end
    end
  end
end
