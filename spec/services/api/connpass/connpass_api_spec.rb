require 'rails_helper'
include Api::Connpass
describe ConnpassApi do
  let(:api) { ConnpassApi.new }
  it '１ページ(１００件以内)の場合' do
    events = api.search(keyword: '名古屋', ym: '201701')
    expect(events.count).to be < 100
  end
  it '２ページ(１００件以上)の場合' do
    events = api.search(keyword: '名古屋', ym: ['201610', '201611'])
    expect(events.count).to be >= 100
  end
  it '３ページ(２００件以上)の場合' do
    events = api.search(keyword: ['愛知', '名古屋'], ym: ['201610', '201611', '201612', '201701'])
    expect(events.count).to be >= 200
  end
  it 'イベントIDを指定した場合' do
    events = api.search(event_id: 30152)
    expect(events.first.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
  end
  it '#find' do
    event = api.find(event_id: 30152)
    expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
  end
end
