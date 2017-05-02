require 'rails_helper'

describe EventCollector do
  let(:collector) { EventCollector.new }
  let(:ym) { Date.today.strftime('%Y%m') }
  it '今月のイベント情報が取得できること' do
    expect{ collector.search([ym]) }.not_to raise_error
  end

  it '全てのサイトからイベントが取得されていること' do
    events = collector.search(['201612'], false)
    classes = events.map { |event| event.class }
    expect(classes).to include Api::Connpass::ConnpassEvent
    expect(classes).to include Api::Doorkeeper::DoorkeeperEvent
    expect(classes).to include Api::Atnd::AtndEvent
  end
end
