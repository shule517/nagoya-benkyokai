class GroupsController < ApplicationController
  def show
    group_events = Event.where('group_title = ?', params[:id])
    @events = group_events.where('started_at > ?', Date.today).order(:started_at).each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
    @events_histories = group_events.where('started_at < ?', Date.today).order(:started_at).reverse.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
  end
end
