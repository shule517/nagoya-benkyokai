# encoding: utf-8
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
          @twitter.tweet("[新着] " + message)
          event.update(tweeted_new: true)
        rescue => e
          Slack.chat_postMessage text: "`#{e}`\n#{message}", username: "lambda", channel: "#lambda-error"
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
        message = "[明日] " + tweet_message(event)
        puts "tweet - #{message}"
        begin
          @twitter.tweet(message)
          event.update(tweeted_tomorrow: true)
        rescue => e
          Slack.chat_postMessage text: "`#{e}`\n#{message}", username: "lambda", channel: "#lambda-error"
          puts e
        end
      end
    end

    def tweet_message(event)
      title = ""
      event.title.split(/[[:space:]]/).each do |str|
        title += str if (title.size + str.size) < 40
      end
      title = event.title[0..40] if title.empty?

      message = "#{event.year}/#{event.month}/#{event.day}(#{event.wday})に開催される勉強会です！\n#{title}\n\nイベントページ：#{event.event_url}\nツイッターリスト：https://twitter.com/nagoya_lambda/lists/nagoya-#{event.event_id}"
      if !event.hash_tag.empty?
        message += "\n##{event.hash_tag}"
      end
      message
    end
  end
end
