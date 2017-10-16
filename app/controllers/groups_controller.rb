class GroupsController < ApplicationController
  def show
    group_events = Event.where('group_title = ?', params[:groupname])
    @event = group_events.select { |event| event.participants.size > 0 }.first
    @events = group_events.scheduled
    @events_histories = group_events.ended
  end
end
