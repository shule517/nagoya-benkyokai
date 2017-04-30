require 'rails_helper'
include Api::Atnd
describe AtndScraping do
  let(:api) { AtndApi }
  context 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！' do
    let(:event) { api.find(keyword: 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！') }
    it 'タイトルが取得できること' do
      expect(event.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！'
    end
    it 'キャッチが取得できること' do
      expect(event.catch).to start_with '【ATEAM TECHとは】'
    end
    it '開始日時が取得できること' do
      expect(event.started_at).to eq Date.parse('2016-10-11T20:00:00.000+09:00')
    end
    it '開催場所が取得できること' do
      expect(event.place).to eq 'エイチーム　本社'
    end
    it '開催場所の住所が取得できること' do
      expect(event.address).to eq '〒450-6432　名古屋市中村区名駅三丁目28番12号　大名古屋ビルヂング 32F'
    end
    it '定員オーバーしたか取得できること' do
      expect(event.limit_over?).to eq false
    end
    it 'ロゴ画像のURLが取得できること' do
      expect(event.logo).to eq 'https://atnd.org/event_images/0008/0890/008_original.jpg?1474957731'
    end
    it '参加人数が取得できること' do
      expect(event.users.count).to eq event.accepted
    end

    describe '参加者の情報が取得できること' do
      let(:atnd_user) { event.users.select { |user| user.atnd_id == '259586' }.first }
      it '全てのSNS情報が取得できること' do
        expect(atnd_user.atnd_id).to eq '259586'
        expect(atnd_user.twitter_id).to eq 'suzukiterminal'
        expect(atnd_user.facebook_id).to eq '1800036413585884'
        expect(atnd_user.name).to eq 's2terminal'
        expect(atnd_user.image_url).to eq 'https://pbs.twimg.com/profile_images/682491356460101632/4l54CzhH_normal.jpg'
      end

      let(:no_social_user) { event.users.select { |user| user.atnd_id == '260559' }.first }
      it 'SNSが未登録なユーザの情報が取得できること' do
        expect(no_social_user.atnd_id).to eq '260559'
        expect(no_social_user.twitter_id).to eq ''
        expect(no_social_user.facebook_id).to eq ''
        expect(no_social_user.name).to eq 'otama567'
        expect(no_social_user.image_url).to eq 'https://atnd.org/images/icon/default_latent.png'
      end
    end

    describe '主催者の情報が取得できること' do
      let(:owners) { event.owners }
      let(:ateam) { owners.select { |user| user.atnd_id == '224579' }.first }
      it {
        expect(owners.count).to eq 1
        expect(ateam.atnd_id).to eq '224579'
        expect(ateam.name).to eq 'Ateam Inc.'
        expect(ateam.twitter_id).to eq ''
        expect(ateam.facebook_id).to eq '935173646549635'
        expect(ateam.image_url).to eq 'https://graph.facebook.com/935173646549635/picture?type=square'
      }
    end
  end

  context '管理者の画像がない場合' do
    let(:event) { api.find(keyword: 'RFC 読書会 - RFC 1034 第1回') }
    let(:owners) { event.owners }
    let(:tss) { owners.select { |user| user.atnd_id == '10209' }.first }
    it {
      expect(owners.count).to eq 1
      expect(tss.atnd_id).to eq '10209'
      expect(tss.name).to eq 'tss_ontap'
      expect(tss.twitter_id).to eq ''
      expect(tss.facebook_id).to eq ''
      expect(tss.image_url).to eq 'https://atnd.org/images/icon/default_latent.png'
    }
  end

  context '管理者がいない場合' do
    let(:event) { api.find(keyword: 'HULFT勉強会 in 名古屋') }
    let(:owners) { event.owners }
    it { expect(owners.count).to eq 0 }
  end
end
