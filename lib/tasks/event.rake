# encoding: utf-8
namespace :event do
  desc "初期化"
  task :init => :environment do
    EventUpdater.call

    time = Time.now
    time += 24*60*60
    tommorow = time.strftime("%Y-%m-%d")
    Event.all.update_all(tweeted_new: true)
    Event.all.where("started_at < ?", tommorow).update_all(tweeted_tomorrow: true)
  end

  desc "イベント情報を更新"
  task :update => :environment do
    EventUpdater.call
    EventTweet.tweet_new
  end

  desc "明日開かれるイベントをツイート"
  task :tweet => :environment do
    EventTweet.tweet_tomorrow
  end
end
