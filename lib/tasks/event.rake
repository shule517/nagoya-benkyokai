# encoding: utf-8
namespace :event do
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
