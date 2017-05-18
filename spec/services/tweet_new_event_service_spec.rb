require 'rails_helper'

describe TweetNewEventService, type: :request do
  include EventHelper

  let(:twitter) { TwitterClient.new }
  let(:target_event) { Api::Atnd::AtndApi.find(event_id: 81945) }
  it '新着ツイートができること', vcr: 'new' do
    StoreEventService.new.call(target_event)
    set_event(started_at: Time.now)

    UpdateTwitterListService.new.call
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true
    expect(event.tweeted_new).to eq false

    TweetNewEventService.new.call
    expect(event.tweeted_new).to eq true
  end
end
