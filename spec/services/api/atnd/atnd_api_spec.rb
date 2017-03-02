require 'rails_helper'
include Api::Atnd
describe AtndApi do
  let(:api) { AtndApi.new }
  it '１ページ(１００件以内)の場合' do
    result = api.search(keyword: '名古屋', ym: '201701')
    expect(result.count).to be < 100
  end
  it '２ページ(１００件以上)の場合' do
    result = api.search(keyword: '名古屋', ym: ['201611', '201612', '201701'])
    expect(result.count).to be > 100
  end
  it '３ページ(２００件以上)の場合' do
    result = api.search(keyword: '名古屋', ym: ['201608', '201609', '201610', '201611', '201612', '201701'])
    expect(result.count).to be > 200
  end
  it 'イベントIDを指定した場合' do
    result = api.search(event_id: 81945)
    expect(result.count).to eq 1
  end
end
