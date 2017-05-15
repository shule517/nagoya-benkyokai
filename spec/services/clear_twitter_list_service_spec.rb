require 'rails_helper'

describe ClearTwitterListService, type: :request do
  let(:twitter) { TwitterClient.new }
  it '開催終了から１週間以内ならリストを削除しないこと', vcr: '6_day_ago' do
    events = [Api::Atnd::AtndApi.find(event_id: 81945)]
    UpdateEventService.new.call(events) # Eventレコードを作成

    event = Event.first
    event.started_at = Time.now
    event.ended_at = 6.day.ago
    event.save

    UpdateTwitterListService.new.call # リストを作成
    expect(twitter.list_exists?(Event.first.twitter_list_url)).to eq true

    ClearTwitterListService.new.call # 一週間以内のため、削除しない
    expect(twitter.list_exists?(Event.first.twitter_list_url)).to eq true
  end

  it '開催終了から一週間経ったらリストを削除すること', vcr: '7_day_ago' do
    events = [Api::Atnd::AtndApi.find(event_id: 81945)]
    UpdateEventService.new.call(events) # Eventレコードを作成

    event = Event.first
    event.started_at = Time.now
    event.ended_at = 7.day.ago
    event.save

    UpdateTwitterListService.new.call # リストを作成
    expect(twitter.list_exists?(Event.first.twitter_list_url)).to eq true

    ClearTwitterListService.new.call # 一週間経ったので削除する
    expect(twitter.list_exists?(Event.first.twitter_list_url)).to eq false
  end
end
