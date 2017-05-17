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

  context 'ATNDの場合' do
    it '勉強会が取得できること', vcr: 'atnd_benkyokai' do
      events = SearchEventService.new.call({ ym: '201705' }, false)
      titles = events.map(&:title)
      expect(titles).to include 'RFC 読書会 - RFC 1034 第 3 回 -' # https://atnd.org/events/87770
    end

    it '勉強会ではないイベントは除外すること', vcr: 'atnd_not_benkyokai' do
      events = SearchEventService.new.call({ ym: ['201705', '201706'] }, false)
      titles = events.map(&:title)
      expect(titles).not_to include '【6/3(土)19:00～】オシャレカフェで立食パーティーin栄'          # https://atnd.org/events/87896
      expect(titles).not_to include '第22回eco検定合格対策「春の一日集中講座」（5月20日名古屋市開催）' # https://atnd.org/events/86049
      expect(titles).not_to include '心の専門家がお届けするアニマルセラピープログラム'                # https://atnd.org/events/88112
      expect(titles).not_to include '介護のストレスケア'                                         # https://atnd.org/events/88105
    end
  end
end
