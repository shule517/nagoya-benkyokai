# encoding: utf-8
require "slack"

namespace :event do
  desc "初期化"
  task init: :environment do
    Slack.chat_postMessage text: "event:init start", username: "lambda", channel: "#lambda-log"
    EventUpdater.call

    time = Time.now
    time += 24 * 60 * 60
    tommorow = time.strftime("%Y-%m-%d")
    Event.all.update_all(tweeted_new: true)
    Event.all.where("started_at < ?", tommorow).update_all(tweeted_tomorrow: true)
    Slack.chat_postMessage text: "event:init end", username: "lambda", channel: "#lambda-log"
  end

  desc "イベント情報を更新"
  task update: :environment do
    Slack.chat_postMessage text: "event:update start", username: "lambda", channel: "#lambda-log"
    EventUpdater.call
    Slack.chat_postMessage text: "event:update end", username: "lambda", channel: "#lambda-log"
  end

  desc "明日開かれるイベントをツイート"
  task tweet: :environment do
    Slack.chat_postMessage text: "event:tweet start", username: "lambda", channel: "#lambda-log"
    EventTweet.tweet_tomorrow
    Slack.chat_postMessage text: "event:tweet end", username: "lambda", channel: "#lambda-log"
  end

  desc "終わった勉強会のツイッターリストを削除する"
  task delete_list: :environment do
    Slack.chat_postMessage text: "event:tweet start", username: "lambda", channel: "#lambda-log"
    DeleteTwitterList.call
    Slack.chat_postMessage text: "event:tweet end", username: "lambda", channel: "#lambda-log"
  end
end
