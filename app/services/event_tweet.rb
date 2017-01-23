# encoding: utf-8
class EventTweet
  class << self
    def tweet_new
      @twitter = TwitterClient.new
      events = Event.where('tweeted_new = ?', false)
      events.each do |event|
        message = tweet_message(event)
        puts "tweet - #{message}"
        begin
          @twitter.tweet("[新着] " + message)
          event.update(tweeted_new: true)
        rescue => e
          puts e
        end
      end
    end

    def tweet_tomorrow
      @twitter = TwitterClient.new
      time = Time.now + (24*60*60)*2
      tomorrow = time.strftime("%Y-%m-%d")
      puts "tomorrow: #{tomorrow}"

      events = Event.where('started_at < ? and tweeted_tomorrow = ?', tomorrow, false)
      events.each do |event|
        messge = "[明日] " + tweet_message(event)
        puts "tweet - #{messge}"
        begin
          @twitter.tweet(messge)
          event.update(tweeted_tomorrow: true)
        rescue => e
          puts e
        end
      end
    end

    def tweet_message(event)
      message = "#{event.year}/#{event.month}/#{event.day}(#{event.wday})に開催される勉強会です！\n#{event.title[0, 70]}\n\nイベントページ：#{event.event_url}\nツイッターリスト：https://twitter.com/nagoya_lambda/lists/nagoya-#{event.event_id}"
      if !event.hash_tag.empty?
        message += "\n##{event.hash_tag}"
      end
      message
    end
  end
end
