class GroupsController < ApplicationController
  def show
    group_events = Event.where('group_title = ?', params[:groupname])
    @event = group_events.select { |event| event.participants.size > 0 }.first.tap do |event|
      event.twitter_list_url = event.twitter_list_url.gsub('nagoya_lambda/', 'nagoya_lambda/lists/') if event.twitter_list_url.present?
    end
    @events = group_events.scheduled.upcoming_events
    @events_histories = group_events.ended.upcoming_events.reverse
  end
end
