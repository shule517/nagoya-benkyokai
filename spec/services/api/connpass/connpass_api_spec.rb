require 'rails_helper'
include Api::Connpass
describe ConnpassApi do
  describe 'search' do
    let(:api) { ConnpassApi.new }
    it '１ページ(１００件以内)の場合' do
      events = api.search(keyword: '名古屋', ym: '201701')
      expect(events.count).to be < 100
    end
    it '２ページ(１００件以上)の場合' do
      events = api.search(keyword: '名古屋', ym: ['201610', '201611'])
      expect(events.count).to be >= 100
    end
    it '３ページ(２００件以上)の場合' do
      events = api.search(keyword: ['愛知', '名古屋'], ym: ['201610', '201611', '201612', '201701'])
      expect(events.count).to be >= 200
    end
    it 'イベントIDを指定した場合' do
      events = api.search(event_id: 30152)
      expect(events.first.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
    end
    it '#find' do
      event = api.find(event_id: 30152)
      expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
    end
  end
  describe 'Scraping' do
    let(:api) { ConnpassApi.new }
    context 'JXUGC #14 Xamarinの場合' do
      let(:event) { api.find(event_id: 30152) }
      it { expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会' }
      it { expect(event.logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png' }
      it { expect(event.catch).to eq 'にゃごやでも話題の Xamarin を触ってみよう！' }
      it { expect(event.started_at).to eq Date.parse('2016-05-15T13:00:00+09:00') }
      it { expect(event.place).to eq '熱田生涯学習センター' }
      it { expect(event.address).to eq '熱田区熱田西町2-13' }
      it { expect(event.group_title).to eq 'JXUG' }
      it { expect(event.group_id).to eq 1134 }
      it { expect(event.group_url).to eq 'https://jxug.connpass.com/' }
      it { expect(event.group_logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/c9/d3/c9d379a73fa278df5fae314abd0d227a.png' }
      it { expect(event.limit_over?).to eq true }
      it { expect(event.accepted).to eq event.users.count }

      let(:shule) { event.users.select { |user| user.connpass_id == 'shule517' }.first }
      it { expect(shule.connpass_id).to eq 'shule517' }
      it { expect(shule.twitter_id).to eq 'shule517' }
      it { expect(shule.name).to eq 'シュール' }
      it { expect(shule.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/b9/93/b99305b6784e742244868ddd5acc8646.png' }
      it { expect(event.owners.count).to eq 4 }

      let(:kuu) { event.users.select { |user| user.connpass_id == 'Kuxumarin' }.first }
      it { expect(kuu.connpass_id).to eq 'Kuxumarin' }
      it { expect(kuu.twitter_id).to eq 'Fumiya_Kume' }
      it { expect(kuu.image_url).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/75/1f/751ff2dde8d0e259e4ad95c77bcda057.png' }
    end

    context 'group_urlがない場合' do
      let(:event) { api.find(keyword: 'ちゅーんさんちでHaskellやると楽しいという会') }
      it { expect(event.users.count).to eq event.accepted }
      it { expect(event.owners.count).to eq 1 }
    end

    context 'JPSPSが表示されない問題を解決' do
      let(:event) { api.find(keyword: 'JPSPS') }
      it { expect(event.title).to eq '第5回 JPSPS SharePoint/Office365名古屋分科勉強会 at GeekBar' }
    end

    context 'Python東海の参加者数が0である問題を解決' do
      let(:event) { api.find(keyword: 'Python東海 第32回勉強会') }
      it { expect(event.users.count).to eq 16 }
    end

  # def test_wine
  #   # 参加者が足りていない場合
  #   api = Connpass.new
  #   events = api.search(['オンザロード'])
  #   events = events.select { |event| event.title =~ /チョコ/ }
  #   event = events.first
  #   users = event.users
  #   assert_equal(event.accepted, users.count)
  #   assert_equal(event.owners.count, 1)
  # end
  end


end
