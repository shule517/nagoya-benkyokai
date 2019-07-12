class EventsController < ApplicationController
  def index
    @events = Event.scheduled.where.not('event_url like ?', 'https://atnd.org/%')
  end

  # おためし機能
  def tag
    @events = Event.scheduled
  end
end
