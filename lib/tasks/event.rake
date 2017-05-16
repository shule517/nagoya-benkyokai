# encoding: utf-8
require 'slack'
require './app/services/http.rb'

module Notifiable
  def notify(task)
    begin
      Slack.chat_postMessage text: "#{task} start", channel: '#test-log', username: 'lambda'
      yield
    rescue => e
      backtrace = e.backtrace.join("\n")
      Slack.chat_postMessage text: "#{task} #{e}\n#{backtrace}", channel: '#test-error', username: 'lambda'
    ensure
      Slack.chat_postMessage text: "#{task} end", channel: '#test-log', username: 'lambda'
    end
  end
end

namespace :event do
  desc '初期化'
  task init: :environment do
    include Notifiable
    notify('event:init') do
      EventUpdater.call
      time = Time.now
      time += 24 * 60 * 60
      tommorow = time.strftime('%Y-%m-%d')
      Event.all.update_all(tweeted_new: true)
      Event.all.where('started_at < ?', tommorow).update_all(tweeted_tomorrow: true)
    end
  end

  desc 'イベント情報を更新(DB+twitter)'
  task update: :environment do
    include Notifiable
    notify('event:update') do
      EventUpdater.new.call
    end
  end

  desc 'イベント情報を更新(DB)'
  task update_db: :environment do
    include Notifiable
    notify('event:update_db') do
      EventUpdater.update(ENV['date'])
    end
  end

  desc '明日開かれるイベントをツイート'
  task tweet: :environment do
    include Notifiable
    notify('event:tweet') do
      EventTweet.tweet_tomorrow
    end
  end

  desc '終わった勉強会のツイッターリストを削除する'
  task delete_list: :environment do
    include Notifiable
    notify('event:delete_list') do
      ClearTwitterListService.new.call
    end
  end
end
