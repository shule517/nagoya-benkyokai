class EventsController < ApplicationController
  def index
    @events = Event.scheduled
    @events.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end

    @events_box = Event.upcoming_events
  end

  # おためし機能
  def tag
    @events = Event.scheduled
    @events.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
  end
end
