class UsersController < ApplicationController
  def show
    @user = User.where(twitter_id: params[:id]).first
    participants = Participant.where(user_id: @user.id)
    event_ids = participants.map { |participant| participant.event_id }
    @events = Event.where(id: event_ids).order(:started_at)
    @events.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
  end
end
