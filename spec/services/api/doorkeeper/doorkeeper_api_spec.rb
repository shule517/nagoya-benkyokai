require 'rails_helper'
include Api::Doorkeeper
describe DoorkeeperApi do
  let(:api) { DoorkeeperApi.new }
  it '１ページ(２０件以内)の場合' do
    result = api.search(keyword: '豊橋', ym: '201701')
    expect(result.count).to be < 20
  end
  it '２ページ(４０件以内)の場合' do
    result = api.search(keyword: '愛知', ym: ['201612', '201701'])
    expect(result.count).to be > 20
  end
  it '３ページ(６０件以内)の場合' do
    result = api.search(keyword: '名古屋', ym: ['201610', '201611', '201612'])
    expect(result.count).to be > 40
  end
  it '検索キーワードが複数の場合' do
    result = api.search(keyword: ['名古屋', '愛知'], ym: '201701')
    expect(result.count).to be > 1
  end
end
