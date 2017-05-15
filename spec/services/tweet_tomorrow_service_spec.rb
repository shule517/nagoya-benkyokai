require 'rails_helper'

describe TweetTomorrowService, type: :request do
  let(:twitter) { TwitterClient.new }
  it '明日開かれる勉強会のツイートができること', vcr: 'tomorrow' do
    events = [Api::Atnd::AtndApi.find(event_id: 81945)]
    UpdateEventService.new.call(events) # Eventレコードを作成

    event = Event.first
    event.started_at = 1.day.since
    event.ended_at = 1.day.since
    event.save

    UpdateTwitterListService.new.call # リストを作成
    expect(twitter.list_exists?(Event.first.twitter_list_url)).to eq true

    event = Event.first
    expect(event.tweeted_tomorrow).to eq false
    TweetTomorrowService.new.call # 明日の勉強会のツイート
    event = Event.first
    expect(event.tweeted_tomorrow).to eq true
  end
end
