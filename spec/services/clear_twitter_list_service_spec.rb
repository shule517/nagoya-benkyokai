require 'rails_helper'

describe ClearTwitterListService, type: :request do
  include EventHelper

  let(:twitter) { TwitterClient.new }
  let(:target_event) { Api::Atnd::AtndApi.find(event_id: 81945) }
  it '開催終了から１週間以内ならリストを削除しないこと', vcr: '6_day_ago' do
    event = StoreEventService.new.call(target_event)
    set_event(event, started_at: Time.now, ended_at: 6.day.ago)

    UpdateTwitterListService.new.call(event)
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true

    ClearTwitterListService.new.call
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true
  end

  it '開催終了から一週間経ったらリストを削除すること', vcr: '7_day_ago' do
    event = StoreEventService.new.call(target_event)
    set_event(event, started_at: Time.now, ended_at: 7.day.ago)

    UpdateTwitterListService.new.call(event)
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true

    ClearTwitterListService.new.call
    expect(twitter.list_exists?(event.twitter_list_url)).to eq false
  end
end
