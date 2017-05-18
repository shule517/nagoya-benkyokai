require 'rails_helper'

describe TweetTomorrowEventService, type: :request do
  include EventHelper

  let(:twitter) { TwitterClient.new }
  let(:target_event) { Api::Atnd::AtndApi.find(event_id: 81945) }
  it '明日開かれる勉強会のツイートができること', vcr: 'tomorrow' do
    StoreEventService.new.call(target_event)
    set_event(started_at: 1.day.since, ended_at: 1.day.since)

    UpdateTwitterListService.new.call
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true
    expect(event.tweeted_tomorrow).to eq false

    TweetTomorrowEventService.new.call
    expect(event.tweeted_tomorrow).to eq true
  end
end
