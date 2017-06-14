require 'slack'

module Notifiable
  def notify(task)
    begin
      Slack.chat_postMessage text: "#{task} start", channel: ENV['SLACK_LOG_CHANNEL'], username: 'lambda'
      yield
    rescue => e
      backtrace = e.backtrace.reject { |trace| trace.include?('/app/vendor') || trace.include?('.rbenv') }.join("\n")
      Slack.chat_postMessage text: "#{task} #{e}\n#{backtrace}", channel: ENV['SLACK_ERROR_CHANNEL'], username: 'lambda'
    ensure
      Slack.chat_postMessage text: "#{task} end", channel: ENV['SLACK_LOG_CHANNEL'], username: 'lambda'
    end
  end
end

namespace :event do
  desc '初期化'
  task init: :environment do
    include Notifiable
    notify('event:init') do
      EventUpdater.new.call

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

  desc '明日開かれるイベントをツイート'
  task tweet: :environment do
    include Notifiable
    notify('event:tweet') do
      EventTweet.tweet_tomorrow
    end
  end
end

namespace :twitter do
  # desc 'ツイッターリストを全て削除する'
  # task delete_lists: :environment do
  #   include Notifiable
  #   notify('event:delete_lists') do
  #     twitter = TwitterClient.new
  #     twitter.lists.each do |list|
  #       twitter.destroy_list(list[:id])
  #     end
  #   end
  # end

  desc '終わった勉強会のツイッターリストを削除する'
  task clear_list: :environment do
    include Notifiable
    notify('twitter:clear_list') do
      ClearTwitterListService.new.call
    end
  end

  desc '新着・明日ツイートのエラー解除'
  task clear_error: :environment do
    include Notifiable
    notify('twitter:clear_error') do
      # 新着ツイートは全て完了したことにする
      Event.all.update_all(tweeted_new: true)
      # 明日ツイートは全て完了したことにする
      Event.where('started_at < ?', Date.tomorrow).update_all(tweeted_tomorrow: true)
    end
  end
end
