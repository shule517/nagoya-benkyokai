require 'rails_helper'
include Api::Atnd

describe AtndScraping, type: :request do
  let(:api) { AtndApi }
  describe 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！' do
    let(:event) { api.find(event_id: 81945) }
    describe 'イベント情報の取得できること', vcr: '#find-event' do
      it { expect(event.source).to eq 'ATND' }
      it { expect(event.event_id).to eq 81945 }
      it { expect(event.event_url).to eq 'https://atnd.org/events/81945' }
      it { expect(event.title).to eq 'エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！' }
      it { expect(event.catch).to start_with '【ATEAM TECHとは】 ゲームやインターネット業界で働く技術者向けに勉強会や交流できる場を設け、新しい気づきや成長につながるような機会を提供することで、技術力の向上や業界のさらなる発展を目指します。' }
      it { expect(event.started_at).to eq Date.parse('2016-10-11T20:00:00.000+09:00') }
      it { expect(event.place).to eq 'エイチーム　本社' }
      it { expect(event.address).to eq '〒450-6432　名古屋市中村区名駅三丁目28番12号　大名古屋ビルヂング 32F' }
      it { expect(event.limit_over?).to eq false }
      it { expect(event.logo).to eq 'https://atnd.org/event_images/0008/0890/008_original.jpg?1474957731' }
      it { expect(event.users.count).to eq event.accepted }
      it { expect(event.group_url).to eq nil }
      it { expect(event.group_id).to eq nil }
      it { expect(event.group_title).to eq nil }
      it { expect(event.group_logo).to eq nil }
    end

    describe '参加者の情報が取得できること', vcr: '#find-users' do
      context '全てのSNSが登録されているユーザの場合' do
        let(:atnd_user) { event.users.select { |user| user.atnd_id == '259586' }.first }
        it { expect(atnd_user.atnd_id).to eq '259586' }
        it { expect(atnd_user.twitter_id).to eq 'suzukiterminal' }
        it { expect(atnd_user.facebook_id).to eq '1800036413585884' }
        it { expect(atnd_user.github_id).to eq '' }
        it { expect(atnd_user.linkedin_id).to eq '' }
        it { expect(atnd_user.name).to eq 's2terminal' }
        it { expect(atnd_user.image_url).to eq 'https://pbs.twimg.com/profile_images/682491356460101632/4l54CzhH_normal.jpg' }
      end

      context 'SNSが未登録なユーザの場合' do
        let(:no_social_user) { event.users.select { |user| user.atnd_id == '260559' }.first }
        it { expect(no_social_user.atnd_id).to eq '260559' }
        it { expect(no_social_user.twitter_id).to eq '' }
        it { expect(no_social_user.facebook_id).to eq '' }
        it { expect(no_social_user.github_id).to eq '' }
        it { expect(no_social_user.linkedin_id).to eq '' }
        it { expect(no_social_user.name).to eq 'otama567' }
        it { expect(no_social_user.image_url).to eq 'https://atnd.org/images/icon/default_latent.png' }
      end
    end

    describe '主催者の情報が取得できること', vcr: '#find-owners' do
      let(:owners) { event.owners }
      let(:ateam) { owners.select { |user| user.atnd_id == '224579' }.first }
      it { expect(owners.count).to eq 1 }
      it { expect(ateam.atnd_id).to eq '224579' }
      it { expect(ateam.twitter_id).to eq '' }
      it { expect(ateam.facebook_id).to eq '935173646549635' }
      it { expect(ateam.github_id).to eq '' }
      it { expect(ateam.linkedin_id).to eq '' }
      it { expect(ateam.name).to eq 'Ateam Inc.' }
      it { expect(ateam.image_url).to eq 'https://graph.facebook.com/935173646549635/picture?type=square' }
    end
  end

  describe '#catch' do
    context 'catchが設定されている場合'
    context 'catchが設定されていない場合'
  end

  describe '#logo' do
    context 'logoが設定されている場合'
    context 'logoが設定されていない場合'
  end

  describe '#get_social_id' do
    describe '#twitter_id' do
      context 'twitter_idが設定されている場合'
      context 'twitter_idが設定されていない場合' # nilであること
    end
    describe '#facebook_id' do
      context 'facebook_idが設定されている場合'
      context 'facebook_idが設定されていない場合' # nilであること
    end
  end

  describe '#users' do
    context '画像が設定されている場合'
    context '画像が設定されていない場合'
    context 'httpsからはじまる場合'
    context 'httpsからはじまらない場合'
    context '参加者がいない場合'
  end

  describe '#owner' do
    context 'owner_info.empty?の場合'
    context '画像が設定されている場合'
    context '画像が設定されていない場合'
    context '管理者がいない場合'
  end

  context '管理者の画像がない場合', vcr: '#find-RFC' do
    let(:event) { api.find(keyword: 'RFC 読書会 - RFC 1034 第1回') }
    let(:owners) { event.owners }
    let(:tss) { owners.select { |user| user.atnd_id == '10209' }.first }
    it { expect(owners.count).to eq 1 }
    it { expect(tss.atnd_id).to eq '10209' }
    it { expect(tss.twitter_id).to eq '' }
    it { expect(tss.facebook_id).to eq '' }
    it { expect(tss.name).to eq 'tss_ontap' }
    it { expect(tss.image_url).to eq 'https://atnd.org/images/icon/default_latent.png' }
  end

  context '管理者がいない場合', vcr: '#find-HULFT' do
    let(:event) { api.find(keyword: 'HULFT勉強会 in 名古屋') }
    let(:owners) { event.owners }
    it { expect(owners.count).to eq 0 }
  end
end
