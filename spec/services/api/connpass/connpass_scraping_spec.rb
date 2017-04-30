require 'rails_helper'
include Api::Connpass
describe ConnpassScraping do
  let(:api) { ConnpassApi }
  context 'JXUGC #14 Xamarinの場合' do
    let(:event) { api.find(event_id: 30152) }
    it 'タイトルが取得できること' do
      expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
    end
    it 'ロゴ画像のURLが取得できること' do
      expect(event.logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png'
    end
    it 'キャッチが取得できること' do
      expect(event.catch).to eq 'にゃごやでも話題の Xamarin を触ってみよう！'
    end
    it '開始日時が取得できること' do
      expect(event.started_at).to eq Date.parse('2016-05-15T13:00:00+09:00')
    end
    it '開催場所が取得できること' do
      expect(event.place).to eq '熱田生涯学習センター'
    end
    it '開催場所の住所が取得できること' do
      expect(event.address).to eq '熱田区熱田西町2-13'
    end
    it 'グループ名が取得できること' do
      expect(event.group_title).to eq 'JXUG'
    end
    it 'グループIDが取得できること' do
      expect(event.group_id).to eq 1134
    end
    it 'グループページのURLが取得できること' do
      expect(event.group_url).to eq 'https://jxug.connpass.com/'
    end
    it 'グループのロゴ画像URLが取得できること' do
      expect(event.group_logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/c9/d3/c9d379a73fa278df5fae314abd0d227a.png'
    end
    it '定員オーバーしたか取得できること' do
      expect(event.limit_over?).to eq true
    end
    it '参加人数が取得できること' do
      expect(event.accepted).to eq event.users.count
    end

    describe '参加者の情報が取得できること' do
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
  end

  context 'group_urlがない場合' do
    let(:event) { api.find(keyword: 'ちゅーんさんちでHaskellやると楽しいという会') }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
    it '主催者人数が取得できること' do
      expect(event.owners.count).to eq 1
    end
  end

  context 'JPSPSが表示されない問題を解決' do
    let(:event) { api.find(keyword: '第5回 JPSPS') }
    it 'イベント情報が取得できること' do
      expect(event.title).to eq '第5回 JPSPS SharePoint/Office365名古屋分科勉強会 at GeekBar'
    end
  end

  context 'Python東海の参加者数が0である問題を解決' do
    let(:event) { api.find(keyword: 'Python東海 第32回勉強会') }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
  end

  context 'チョコ meets ワインの参加者数が足りてない問題を解決' do
    let(:event) { api.find(event_id: 51037) }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
    it '主催者人数が取得できること' do
      expect(event.owners.count).to eq 1
    end
  end
end
