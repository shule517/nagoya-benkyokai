require 'rails_helper'

describe TweetNewService, type: :request do
  let(:twitter) { TwitterClient.new }
  it '新着ツイートができること', vcr: 'new' do
    events = [Api::Atnd::AtndApi.find(event_id: 81945)]
    UpdateEventService.new.call(events) # Eventレコードを作成

    event = Event.first
    event.started_at = Time.now
    event.ended_at = 6.day.ago
    event.save

    UpdateTwitterListService.new.call # リストを作成
    expect(twitter.list_exists?(Event.first.twitter_list_url)).to eq true

    event = Event.first
    expect(event.tweeted_new).to eq false
    TweetNewService.new.call # 新着ツイート
    event = Event.first
    expect(event.tweeted_new).to eq true
  end
end
