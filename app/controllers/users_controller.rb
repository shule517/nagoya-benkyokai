class UsersController < ApplicationController
  def show
    @user = User.find_by(twitter_id: params[:userid])
    participants = Participant.where(user_id: @user.id)
    event_ids = participants.map(&:event_id)
    users_events = Event.where('id in (?)', event_ids)

    @events = users_events.scheduled.order(:started_at).each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
    @events_histories = users_events.ended.order(:started_at).reverse.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
  end
end
