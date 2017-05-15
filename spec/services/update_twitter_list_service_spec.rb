require 'rails_helper'

describe UpdateTwitterListService, type: :request do
  let(:twitter) { TwitterClient.new }
  it 'リストを作成すること', vcr: 'create' do
    events = [Api::Atnd::AtndApi.find(event_id: 81945)]
    UpdateEventService.new.call(events) # Eventレコードを作成

    event = Event.first
    event.started_at = Time.now
    event.save

    UpdateTwitterListService.new.call # リストを作成

    url = Event.first.twitter_list_url
    expect(twitter.list_exists?(url)).to eq true

    list = twitter.list(url)
    expect(list.name).to eq 'エイチームの開発勉強会『ATEAM TECH』'
    expect(list.description).to eq '2017/5/15(月) エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
    expect(list.member_count).to eq 6
  end

  it 'リストの更新ができること', vcr: 'update' do
    events = [Api::Atnd::AtndApi.find(event_id: 81945)]
    UpdateEventService.new.call(events) # Eventレコードを作成

    event = Event.first
    event.started_at = Time.now
    event.save

    UpdateTwitterListService.new.call # リストを作成

    url = Event.first.twitter_list_url
    expect(twitter.list_exists?(url)).to eq true

    list = twitter.list(url)
    expect(list.name).to eq 'エイチームの開発勉強会『ATEAM TECH』'
    expect(list.description).to eq '2017/5/15(月) エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
    expect(list.member_count).to eq 6

    event = Event.first
    event.title = '更新『ATEAM TECH』'
    event.started_at = Time.now
    event.save

    UpdateTwitterListService.new.call # リストを更新

    url = Event.first.twitter_list_url
    list = twitter.list(url)
    expect(list.name).to eq '更新『ATEAM TECH』'
    expect(list.description).to eq '2017/5/15(月) 更新『ATEAM TECH』'
    expect(list.member_count).to eq 6
  end
end
