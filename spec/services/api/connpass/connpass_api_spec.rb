require 'rails_helper'
include Api::Connpass

describe ConnpassApi, type: :request do
  let(:api) { ConnpassApi }
  it '１ページ(１００件以内)の場合', vcr: '#search-1page' do
    events = api.search(keyword: '名古屋', ym: '201701')
    expect(events.count).to be < 100
    expect(events.uniq.size).to eq events.size
  end

  it '２ページ(１００件以上)の場合', vcr: '#search-2page' do
    events = api.search(keyword: '名古屋', ym: ['201610', '201611'])
    expect(events.count).to be >= 100
    expect(events.uniq.size).to eq events.size
  end

  it '３ページ(２００件以上)の場合', vcr: '#search-3page' do
    events = api.search(keyword: ['愛知', '名古屋'], ym: ['201610', '201611', '201612', '201701'])
    expect(events.count).to be >= 200
    expect(events.uniq.size).to eq events.size
  end

  it 'イベントIDを指定した場合', vcr: '#search-event_id' do
    events = api.search(event_id: 30152)
    expect(events.first.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
  end

  it '#find', vcr: '#find' do
    event = api.find(event_id: 30152)
    expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
  end
end
