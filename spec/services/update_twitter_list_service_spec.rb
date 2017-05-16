require 'rails_helper'

describe UpdateTwitterListService, type: :request do
  def event
    Event.first
  end

  def set_event(param)
    event = Event.first
    param.each do |k, v|
      eval("event.#{k} = '#{v}'")
    end
    event.save
  end

  def twitter_url
    event.twitter_list_url
  end

  def list
    twitter.list(twitter_url)
  end

  let(:twitter) { TwitterClient.new }
  let(:events) { [Api::Atnd::AtndApi.find(event_id: 81945)] }
  it 'リストを作成すること', vcr: 'create' do
    UpdateEventService.new.call(events)
    set_event(started_at: Time.now)

    UpdateTwitterListService.new.call
    expect(twitter.list_exists?(twitter_url)).to eq true
    expect(list.name).to eq 'エイチームの開発勉強会『ATEAM TECH』'
    expect(list.description).to eq '2017/5/16(火) エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
    expect(list.member_count).to eq 6
  end

  it 'リストの更新ができること', vcr: 'update' do
    UpdateEventService.new.call(events)
    set_event(started_at: Time.now)

    UpdateTwitterListService.new.call
    expect(twitter.list_exists?(twitter_url)).to eq true
    expect(list.name).to eq 'エイチームの開発勉強会『ATEAM TECH』'
    expect(list.description).to eq '2017/5/16(火) エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
    expect(list.member_count).to eq 6

    set_event(title: '更新『ATEAM TECH』', started_at: Time.now)
    UpdateTwitterListService.new.call
    expect(list.name).to eq '更新『ATEAM TECH』'
    expect(list.description).to eq '2017/5/16(火) 更新『ATEAM TECH』'
    expect(list.member_count).to eq 6
  end
end
