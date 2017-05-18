require 'tweet_event_service'

class EventUpdater
  def call
    SearchEventService.new.call(ym: collect_period).each do |target_event|
      event = StoreEventService.new.call(target_event)
      UpdateTwitterListService.new.call(event)
    end
    TweetNewEventService.new.call
  end

  def collect_period
    now = Time.now
    day = 24 * 60 * 60
    month = 30 * day
    3.times.map { |i| (now + i * month).strftime('%Y%m') }
  end
end
