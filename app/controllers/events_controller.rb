class EventsController < ApplicationController
  def index
    @events = Event.all.order(:started_at)
  end
end
