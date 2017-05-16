require 'rails_helper'

describe ClearTwitterListService, type: :request do
  def set_event(param)
    event = Event.first
    param.each do |k, v|
      eval("event.#{k} = '#{v}'")
    end
    event.save
  end

  let(:twitter) { TwitterClient.new }
  let(:events) { [Api::Atnd::AtndApi.find(event_id: 81945)] }
  let(:event) { Event.first }
  it '開催終了から１週間以内ならリストを削除しないこと', vcr: '6_day_ago' do
    UpdateEventService.new.call(events)
    set_event(started_at: Time.now, ended_at: 6.day.ago)

    UpdateTwitterListService.new.call
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true

    ClearTwitterListService.new.call
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true
  end

  it '開催終了から一週間経ったらリストを削除すること', vcr: '7_day_ago' do
    UpdateEventService.new.call(events)
    set_event(started_at: Time.now, ended_at: 7.day.ago)

    UpdateTwitterListService.new.call
    expect(twitter.list_exists?(event.twitter_list_url)).to eq true

    ClearTwitterListService.new.call
    expect(twitter.list_exists?(event.twitter_list_url)).to eq false
  end
end
