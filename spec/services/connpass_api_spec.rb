require 'rails_helper'
describe ConnpassApi do
  let(:api) { ConnpassApi.new }
  it '１００件以内の場合' do
    result = api.search(['名古屋'], ['201701'])
    expect(result.count).to eq 40
  end
  it '１００件以上の場合' do
    result = api.search(['名古屋'], ['201610', '201611'])
    expect(result.count).to eq 109
  end
  it '２００件以上の場合' do
    result = api.search(['愛知', '名古屋'], ['201610', '201611', '201612', '201701'])
    expect(result.count).to eq 205
  end
end
