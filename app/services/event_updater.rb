class EventUpdater
  def call
    events = SearchEventService.new.call(ym: collect_period)
    UpdateEventService.new.call(events)
    UpdateTwitterListService.new.call
  end

  def collect_period
    now = Time.now
    day = 24 * 60 * 60
    month = 30 * day
    3.times.map { |i| (now + i * month).strftime('%Y%m') }
  end
end
