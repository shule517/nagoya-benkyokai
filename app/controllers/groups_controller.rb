class GroupsController < ApplicationController
  def show
    @events = Event.where('group_title = ? and started_at > ?', params[:id], Date.today).order(:started_at).each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end

    @events_histories = Event.where('group_title = ? and started_at < ?', params[:id], Date.today).order(:started_at).reverse.each do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
  end
end
