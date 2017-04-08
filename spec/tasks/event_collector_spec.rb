require 'rails_helper'

describe EventCollector do
  let(:collector) { EventCollector.new }
  let(:ym) { Date.today.strftime('%Y%m') }
  it '今月のイベント情報が取得できること' do
    expect{ collector.search([ym]) }.not_to raise_error
  end
end
