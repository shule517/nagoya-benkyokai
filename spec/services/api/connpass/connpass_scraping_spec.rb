require 'rails_helper'
include Api::Connpass

describe ConnpassScraping, type: :request do
  let(:api) { ConnpassApi }
  context 'JXUGC #14 Xamarinの場合' do
    let(:event) { api.find(event_id: 30152) }
    it 'イベント情報が取得できること', vcr: '#find-event' do
      expect(event.title).to eq 'JXUGC #14 Xamarin ハンズオン 名古屋大会'
      expect(event.logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png'
      expect(event.catch).to start_with 'にゃごやでも話題の Xamarin を触ってみよう！<br>こんにちは。エクセルソフトの田淵です。 今話題の Xamarin を名古屋でも触ってみましょう！'
      expect(event.started_at).to eq Date.parse('2016-05-15T13:00:00+09:00')
      expect(event.place).to eq '熱田生涯学習センター'
      expect(event.address).to eq '熱田区熱田西町2-13'
      expect(event.group_title).to eq 'JXUG'
      expect(event.group_id).to eq 1134
      expect(event.group_url).to eq 'https://jxug.connpass.com/'
      expect(event.group_logo).to eq 'https://connpass-tokyo.s3.amazonaws.com/thumbs/c9/d3/c9d379a73fa278df5fae314abd0d227a.png'
      expect(event.limit_over?).to eq true
      expect(event.accepted).to eq event.users.count
    end

    describe '参加者の情報が取得できること', vcr: '#find-users' do
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

  context 'group_urlがない場合', vcr: '#find-no_group' do
    let(:event) { api.find(keyword: 'ちゅーんさんちでHaskellやると楽しいという会') }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
    it '主催者人数が取得できること' do
      expect(event.owners.count).to eq 1
    end
  end

  context 'JPSPSが表示されない問題を解決', vcr: '#find-JPSPS' do
    let(:event) { api.find(keyword: '第5回 JPSPS') }
    it 'イベント情報が取得できること' do
      expect(event.title).to eq '第5回 JPSPS SharePoint/Office365名古屋分科勉強会 at GeekBar'
    end
  end

  context 'Python東海の参加者数が0である問題を解決', vcr: '#find-no_users' do
    let(:event) { api.find(keyword: 'Python東海 第32回勉強会') }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
  end

  context 'チョコ meets ワインの参加者数が足りてない問題を解決', vcr: '#find-less_users' do
    let(:event) { api.find(event_id: 51037) }
    it '参加者人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end
    it '主催者人数が取得できること' do
      expect(event.owners.count).to eq 1
    end
  end

  describe '#catch' do
    context 'キャッチコピーが存在する場合', vcr: '#catch-catch_exist' do
      let(:event) { api.find(event_id: 55649) }
      it { expect(event.catch).to start_with 'ゼロから作る Deep Learning 読書会＋ハンズオン その2<br>機械学習 名古屋 分科会 機械学習名古屋 勉強会の分科会です。 この分科会では、より理論・実装に重きを置いた勉強をしていきます。' }
    end

    context 'キャッチコピーが存在しない場合', vcr: '#catch-catch_not_exist' do
      let(:event) { api.find(event_id: 55925) }
      it { expect(event.catch).to start_with '概要 HFと有限の世界を勉強しましょう。 第7回は[1]のIV.5.9、第一不完全性定理のあたりを読みます. 予習不要' }
    end
  end
end
