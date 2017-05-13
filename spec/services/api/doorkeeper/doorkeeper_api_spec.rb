require 'rails_helper'
include Api::Doorkeeper

describe DoorkeeperApi, type: :request do
  let(:api) { DoorkeeperApi }
  it '１ページ(２０件以内)の場合', vcr: '#search-1page' do
    events = api.search(keyword: '豊橋', ym: '201701')
    expect(events.count).to be < 20
    expect(events.uniq.size).to eq events.size
  end

  it '２ページ(４０件以内)の場合', vcr: '#search-2page' do
    events = api.search(keyword: '愛知', ym: ['201612', '201701'])
    expect(events.count).to be > 20
    expect(events.uniq.size).to eq events.size
  end

  it '３ページ(６０件以内)の場合', vcr: '#search-3page' do
    events = api.search(keyword: '名古屋', ym: ['201610', '201611', '201612'])
    expect(events.count).to be > 40
    expect(events.uniq.size).to eq events.size
  end

  it '検索キーワードが複数の場合', vcr: '#search-keywords' do
    events = api.search(keyword: ['名古屋', '愛知'], ym: '201701')
    expect(events.count).to be > 1
  end

  it 'イベントIDを指定した場合', vcr: '#search-event_id' do
    events = api.search(event_id: 45257)
    expect(events.first.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー'
  end

  it '#find', vcr: '#find' do
    event = api.find(event_id: 45257)
    expect(event.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー'
  end
end
