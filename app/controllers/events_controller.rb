class EventsController < ApplicationController
  def index
    @events = Event.scheduled
  end

  # おためし機能
  def tag
    @events = Event.scheduled
  end
end
