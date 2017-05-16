require 'rails_helper'

describe TweetTomorrowEventService, type: :request do
  include EventHelper

  let(:twitter) { TwitterClient.new }
  let(:events) { [Api::Atnd::AtndApi.find(event_id: 81945)] }
  it '明日開かれる勉強会のツイートができること', vcr: 'tomorrow' do
    UpdateEventService.new.call(events) # Eventレコードを作成
    set_event(started_at: 1.day.since, ended_at: 1.day.since)

    UpdateTwitterListService.new.call # リストを作成
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true
    expect(event.tweeted_tomorrow).to eq false

    TweetTomorrowEventService.new.call # 明日の勉強会のツイート
    expect(event.tweeted_tomorrow).to eq true
  end
end
