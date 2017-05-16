require 'rails_helper'

describe TweetNewEventService, type: :request do
  def set_event(param)
    event = Event.first
    param.each do |k, v|
      eval("event.#{k} = '#{v}'")
    end
    event.save
  end

  def event
    Event.first
  end

  let(:twitter) { TwitterClient.new }
  let(:events) { events = [Api::Atnd::AtndApi.find(event_id: 81945)] }
  it '新着ツイートができること', vcr: 'new' do
    UpdateEventService.new.call(events)
    set_event(started_at: Time.now)

    UpdateTwitterListService.new.call
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true
    expect(event.tweeted_new).to eq false

    TweetNewEventService.new.call
    expect(event.tweeted_new).to eq true
  end
end
