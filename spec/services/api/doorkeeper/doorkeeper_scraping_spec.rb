require 'rails_helper'
include Api::Doorkeeper

describe DoorkeeperScraping, type: :request do
  let(:api) { DoorkeeperApi }
  describe '#find' do
    # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
    let(:event) { api.find(event_id: 45257) }
    describe 'イベント情報が取得できること', vcr: '#find' do
      it {
        expect(event.source).to eq 'Doorkeeper'
        expect(event.event_id).to eq 45257
        expect(event.event_url).to eq 'https://geekbar.doorkeeper.jp/events/45257'
        expect(event.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー'
        expect(event.logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/events_banners/45257_normal_1463562966_%E5%90%8D%E5%8F%A4%E5%B1%8B%E3%82%AE%E3%83%BC%E3%82%AF%E3%83%90%E3%83%BC%E3%83%AD%E3%82%B4.png'
        expect(event.started_at).to eq Date.parse('2016-06-13T10:30:00.000Z')
        expect(event.place).to eq 'Club Adriana'
        expect(event.address).to eq '名古屋市中区葵1-27-37シティハイツ1F'
        expect(event.group_title).to eq '名古屋ギークバー'
        expect(event.group_id).to eq 1995
        expect(event.group_url).to eq 'https://geekbar.doorkeeper.jp/'
        expect(event.group_logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/groups_logos/1995_normal_1380975297_251035_156371434432231_4785187_n.jpg'
      }
    end
  end

  describe '#users' do
    let(:users) { event.users }
    context '参加者がいる場合', vcr: '#users-exist' do
      # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
      let(:event) { api.find(event_id: 45257) }
      it { expect(users.count + 3).to eq event.accepted } # 3人アカウント非表示
    end
    context '参加者がいない場合', vcr: '#users-not_exist' do
      # 第37回 concrete5 の日 https://concrete5nagoya.doorkeeper.jp/events/59441
      let(:event) { api.find(event_id: 59441) }
      it { expect(users.count).to eq 0 }
    end
  end

  describe '#user' do
    # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
    let(:event) { api.find(event_id: 45257) }
    let(:users) { event.users }
    context '画像が設定されている場合'
    context '画像が設定されていない場合'
    describe '参加者の情報が取得できること', vcr: '#users' do
      let(:user) { users.select { |user| user.twitter_id == 'shule517' }.first }
      it { expect(user.twitter_id).to eq 'shule517' }
      it { expect(user.name).to eq 'シュール' }
      it { expect(user.image_url).to eq 'https://dzpp79ucibp5a.cloudfront.net/users_avatar_files/295014_original_1464427238_PeerstPlayer_Icon_normal.png' }
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
  end

  describe '#owners' do
    # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
    let(:event) { api.find(event_id: 45257) }
    let(:owners) { event.owners }
    describe '管理者の情報が取得できること', vcr: '#owners' do
      it { expect(owners.count).to eq 1 }
    end
    context 'owner_info.empty?の場合'
    context '管理者がいない場合'
  end

  describe '#owner' do
    # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
    let(:event) { api.find(event_id: 45257) }
    let(:owners) { event.owners }
    describe '管理者の情報が取得できること', vcr: '#owner' do
      let (:owner)  { owners.select { |user| user.twitter_id == 'Dominion525' }.first }
      it { expect(owner.twitter_id).to eq 'Dominion525' }
      it { expect(owner.name).to eq 'どみにをん525' }
      it { expect(owner.image_url).to eq 'https://graph.facebook.com/100001033554537/picture' }
    end
    context '画像が設定されている場合'
    context '画像が設定されていない場合'
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
  end

  describe '#catch', vcr: '#catch' do
    let(:event) { api.find(event_id: 60104) }
    context 'catchが設定されている場合' do
      it 'キャッチコピーが取得できること' do
        expect(event.catch).to start_with '「Scratch Day &amp; Hour of Code in 豊橋」を全国のCoderDojoに合わせて開催します。今回はScratchやTickle（iPadを使用）、Scratch制御のリモコンカー等のワークショップを行います。'
      end
    end
    context 'catchが設定されていない場合'
  end

  describe '#logo' do
    context 'logoが設定されている場合', vcr: '#logo-exist' do
      # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
      let(:event) { api.find(event_id: 45257) }
      it { expect(event.logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/events_banners/45257_normal_1463562966_%E5%90%8D%E5%8F%A4%E5%B1%8B%E3%82%AE%E3%83%BC%E3%82%AF%E3%83%90%E3%83%BC%E3%83%AD%E3%82%B4.png' }
    end
    context 'logoが設定されていない場合', vcr: '#logo-not_exist' do
      # a-blog cms 勉強会 in 名古屋 2017/05 https://ablogcms-nagoya.doorkeeper.jp/events/59695
      let(:event) { api.find(event_id: 59695) }
      it 'イベントロゴが設定されていない場合は、グループロゴが設定されること' do
        expect(event.logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/groups_logos/7293_normal_1452048885_a.png'
      end
    end
  end

  describe '#group_logo' do
    context 'グループロゴが設定されている場合', vcr: '#group_logo-exist' do
      # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
      let(:event) { api.find(event_id: 45257) }
      it { expect(event.group_logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/groups_logos/1995_normal_1380975297_251035_156371434432231_4785187_n.jpg' }
    end
    context 'グループロゴが設定されていない場合', vcr: '#group_logo-not_exist' do
      # 5月26日（金）個別相談会 ＜夜の部＞ https://jimdocafe-hakata.doorkeeper.jp/
      let(:event) { api.find(event_id: 60349) }
      it { expect(event.group_logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/assets/doorkeeper_group_normal-125b448b722fa8c158516cf4b86aafda26b442af55a001418b0eb2acf7117961.gif' }
    end
  end
end
