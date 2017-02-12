class EventsController < ApplicationController
  def index
    today = Time.now.strftime('%Y-%m-%d')
    @events = Event.all.where(['started_at > ?', today]).order(:started_at)

    @events.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/')
    end
  end
end
