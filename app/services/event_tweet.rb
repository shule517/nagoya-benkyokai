# encoding: utf-8
class EventTweet
  class << self
    def call
      puts "tweet"
      @twitter = TwitterClient.new
      tweet_new
      tweet_tomorrow
    end

    def tweet_new
      events = Event.where('tweeted_new = ?', false)
      events.each do |event|
        @twitter.tweet("[新着] " + tweet_message(event))
        puts "tweet - #{event.title}"
        event.update(tweeted_new: true)
      end
    end

    def tweet_tomorrow
      time = Time.now + (24*60*60)*2
      tomorrow = time.strftime("%Y-%m-%d")
      puts "tomorrow: #{tomorrow}"

      events = Event.where('started_at < ? and tweeted_tomorrow = ?', tomorrow, false)
      events.each do |event|
        @twitter.tweet("[明日] " + tweet_message(event))
        puts "tweet - #{event.title}"
        event.update(tweeted_tomorrow: true)
      end
    end

    def tweet_message(event)
      message = "#{event.year}/#{event.month}/#{event.day}(#{event.wday})に開催される勉強会です！\n#{event.title}\n\nイベントページ：#{event.event_url}\nツイッターリスト：https://twitter.com/nagoya_lambda/lists/nagoya-#{event.event_id}"
      if !event.hash_tag.empty?
        message += "\n##{event.hash_tag}"
      end
      message
    end
  end
end
