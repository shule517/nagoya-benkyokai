require 'rails_helper'
describe AtndApi do
  let(:api) { AtndApi.new }
  it '１００件以内の場合' do
    result = api.search(['名古屋'], ['201701'])
    expect(result.count).to eq 23
  end
  it '１００件以上の場合' do
    result = api.search(['名古屋'], ['201611', '201612', '201701'])
    expect(result.count).to eq 108
  end
  it '２００件以上の場合' do
    result = api.search(['名古屋'], ['201608', '201609', '201610', '201611', '201612', '201701'])
    expect(result.count).to eq 224
  end
end
