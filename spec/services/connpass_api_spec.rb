require 'rails_helper'
describe ConnpassApi do
  let(:api) { ConnpassApi.new }
  it '１ページ(１００件以内)の場合' do
    result = api.search(['名古屋'], ['201701'])
    expect(result.count).to eq 40
  end
  it '２ページ(１００件以上)の場合' do
    result = api.search(['名古屋'], ['201610', '201611'])
    expect(result.count).to eq 109
  end
  it '３ページ(２００件以上)の場合' do
    result = api.search(['愛知', '名古屋'], ['201610', '201611', '201612', '201701'])
    expect(result.count).to eq 205
  end
end
