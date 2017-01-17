class EventsController < ApplicationController
  def index
    today = Time.now.strftime("%Y-%m-%d")
    @events = Event.all.where(["started_at > ?", today]).order(:started_at)
  end
end
