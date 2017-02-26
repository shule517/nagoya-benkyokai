require 'rails_helper'
describe AtndApi do
  let(:api) { AtndApi.new }
  it '１ページ(１００件以内)の場合' do
    result = api.search(['名古屋'], ['201701'])
    expect(result.count).to eq 23
  end
  it '２ページ(１００件以上)の場合' do
    result = api.search(['名古屋'], ['201611', '201612', '201701'])
    expect(result.count).to eq 108
  end
  it '３ページ(２００件以上)の場合' do
    result = api.search(['名古屋'], ['201608', '201609', '201610', '201611', '201612', '201701'])
    expect(result.count).to eq 224
  end
end
