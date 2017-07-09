class EventsController < ApplicationController
  def index
    @events = Event.where('started_at > ?', Date.today).order(:started_at)
    @events.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
  end

  # おためし機能
  def tag
    @events = Event.where('started_at > ?', Date.today).order(:started_at)
    @events.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
  end
end
