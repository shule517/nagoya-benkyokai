require 'rails_helper'

describe SearchEventService, type: :request do
  let(:ym) { Date.today.strftime('%Y%m') }
  it '今月のイベント情報が取得できること', vcr: '#search' do
    expect { SearchEventService.new.call([ym]) }.not_to raise_error
  end

  it '全てのサイトからイベントが取得されていること', vcr: '#search-all' do
    events = SearchEventService.new.call(['201612'], false)
    classes = events.map { |event| event.class }
    expect(classes).to include Api::Connpass::ConnpassEvent
    expect(classes).to include Api::Doorkeeper::DoorkeeperEvent
    expect(classes).to include Api::Atnd::AtndEvent
  end

  it '５月の場合', vcr: '#search-201705' do
    events = SearchEventService.new.call(['201705'], false)
    titles = events.map { |event| event.title }
    expect(titles).to include '公開アップルップル社内勉強会 Vol.36' # Doorkeeper 2017-05-15
    expect(titles).to include 'WellHashアンベール（お披露目）会＠名古屋ギークバー' # Doorkeeper 2017-05-15
  end
end
