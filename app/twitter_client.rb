#encoding: utf-8
require "twitter"
require_relative './event_collecter'

class TwitterClient
  def update
    ym = Time.now.strftime("%Y%m")
    events = EventCollecter.search([ym])
    today = Time.now.strftime("%Y-%m-%d")
    events.select! {|event| event.started_at.slice(0, 10) == today}

    puts "events.count:#{events.count} - #{today}"
    events.each do |event|
      puts event
      message = "今日は「#{event.title}」が開催されます！\n#{event.event_url}\nhttps://twitter.com/nagoya_lambda/lists/nagoya-#{event.event_id}/members"
      if !event.hash_tag.empty?
        message += "\n##{event.hash_tag}"
      end
      tweet(message)
    end
  end

  private
  def tweet(message)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "BrgZWFqqRtEWhexY9iEVNUJmv"
      config.consumer_secret     = "B9IUnDFDVNtPRRvw5oYSiqI5WTH7SEj0vgAz6w06Xhaxnz8knI"
      config.access_token        = "803579039843614722-QYlrM8Xo51LsR537tOs4g17UyNopiJ2"
      config.access_token_secret = "jh8nwfMrhsy5RBAmwR6t2pNtn2svHhaBUN3jx3RncGfwg"
    end
    client.update(message)
  end
end
