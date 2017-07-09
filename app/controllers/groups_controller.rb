class GroupsController < ApplicationController
  def show
    @user = User.find_by(twitter_id: params[:id])
    participants = Participant.where(user_id: @user.id)
    event_ids = participants.map { |participant| participant.event_id }

    @events = Event.where('id in (?) and started_at > ?', event_ids, Date.today).order(:started_at).each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end

    @events_histories = Event.where('id in (?) and started_at < ?', event_ids, Date.today).order(:started_at).reverse.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
  end
end
