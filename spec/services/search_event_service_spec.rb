require 'rails_helper'

describe SearchEventService, type: :request do
  it '全てのサイトからイベントが取得されていること', vcr: '#search-all' do
    events = SearchEventService.new.call({ ym: '201612' }, false)
    classes = events.map(&:class)
    expect(classes).to include Api::Connpass::ConnpassEvent
    expect(classes).to include Api::Doorkeeper::DoorkeeperEvent
    expect(classes).to include Api::Atnd::AtndEvent
    titles = events.map(&:title)
    expect(titles).to include 'NGK2016B 昼の部'               # connpass
    expect(titles).to include 'ものづくりナイト@名古屋ギークバー' # Doorkeeper
    expect(titles).to include '名古屋アプリ開発者ミーティング'    # ATND
  end

  it '2017/05のDoorkeeperのイベントが取得できること', vcr: '#search-201705' do
    events = SearchEventService.new.call({ ym: '201705' }, false)
    titles = events.map(&:title)
    expect(titles).to include '公開アップルップル社内勉強会 Vol.36' # Doorkeeper 2017-05-15
    expect(titles).to include 'WellHashアンベール（お披露目）会＠名古屋ギークバー' # Doorkeeper 2017-05-15
  end
end
