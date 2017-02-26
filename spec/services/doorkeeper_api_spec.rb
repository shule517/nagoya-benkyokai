require 'rails_helper'
describe DoorkeeperApi do
  let(:api) { DoorkeeperApi.new }
  it '１ページ(２０件以内)の場合' do
    result = api.search(['名古屋'], ['201701'])
    expect(result.count).to eq 15
  end
  it '２ページ(４０件以内)の場合' do
    result = api.search(['愛知'], ['201612', '201701'])
    expect(result.count).to eq 31
  end
  it '３ページ(６０件以内)の場合' do
    result = api.search(['名古屋'], ['201610', '201611', '201612'])
    expect(result.count).to eq 72
  end
end
