require 'slack'

class EventTweet
  class << self
    def tweet_new
      @twitter = TwitterClient.new
      events = Event.where('tweeted_new = ?', false)
      events.each do |event|
        message = tweet_message(event)
        puts "tweet - #{message}"
        begin
          @twitter.tweet('[新着] ' + message)
          event.update(tweeted_new: true)
        rescue Tweet140OverError => e
          NotifyService.new.send_message("Tweet140OverError\n#{message}")
        rescue => e
          NotifyService.new.call(e, "EventTweet.tweet_new(event-id:#{event.event_id})")
          puts e
        end
      end
    end

    def tweet_tomorrow
      @twitter = TwitterClient.new
      time = Time.now + (24 * 60 * 60) * 2
      tomorrow = time.strftime('%Y-%m-%d')
      puts "tomorrow: #{tomorrow}"

      events = Event.where('started_at < ? and tweeted_tomorrow = ?', tomorrow, false)
      events.each do |event|
        message = '[明日] ' + tweet_message(event)
        puts "tweet - #{message}"
        begin
          @twitter.tweet(message)
          event.update(tweeted_tomorrow: true)
        rescue Tweet140OverError => e
          NotifyService.new.send_message("Tweet140OverError\n#{message}")
        rescue => e
          NotifyService.new.call(e, "EventTweet.tweet_tomorrow(event-id:#{event.event_id})")
          puts e
        end
      end
    end

    def tweet_message(event)
      message = "#{date(event)}に開催される勉強会です！\n#{title(event)}\n\nイベントページ：#{event.event_url}"
      if event.twitter_list_url
        message += "\nツイッターリスト：#{event.twitter_list_url}"
      end
      message += "\n##{event.hash_tag}" if event.hash_tag.present?
      message
    end

    def date(event)
      "#{event.month}/#{event.day}(#{event.wday})"
    end

    def title(event)
      title = ''
      event.title.split(/[[:space:]]/).each do |str|
        title += str if (title.size + str.size) < 40
      end
      title = event.title[0..40] if title.empty?
      title
    end
  end
end
