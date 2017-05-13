require 'rails_helper'
include Api::Doorkeeper

describe DoorkeeperScraping, type: :request do
  let(:api) { DoorkeeperApi }
  describe 'リモート開発 de ナイト' do
    let(:event) { api.find(event_id: 45257) }
    it 'イベント情報が取得できること', vcr: '#find-event' do
      expect(event.source).to eq 'Doorkeeper'
      expect(event.event_id).to eq 45257
      expect(event.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー'
      expect(event.logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/events_banners/45257_normal_1463562966_%E5%90%8D%E5%8F%A4%E5%B1%8B%E3%82%AE%E3%83%BC%E3%82%AF%E3%83%90%E3%83%BC%E3%83%AD%E3%82%B4.png'
      expect(event.started_at).to eq Date.parse('2016-06-13T10:30:00.000Z')
      expect(event.place).to eq 'Club Adriana'
      expect(event.address).to eq '名古屋市中区葵1-27-37シティハイツ1F'
      expect(event.group_title).to eq '名古屋ギークバー'
      expect(event.group_id).to eq 1995
      expect(event.group_url).to eq 'https://geekbar.doorkeeper.jp/'
      expect(event.group_logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/groups_logos/1995_normal_1380975297_251035_156371434432231_4785187_n.jpg'
    end

    describe '参加者の情報が取得できること', vcr: '#find-users' do
      let(:shule) { event.users.select { |user| user.twitter_id == 'shule517' }.first }
      it { expect(event.users.count + 3).to eq event.accepted } # 3人アカウント非表示
      it { expect(shule.twitter_id).to eq 'shule517' }
      it { expect(shule.name).to eq 'シュール' }
      it { expect(shule.image_url).to eq 'https://dzpp79ucibp5a.cloudfront.net/users_avatar_files/295014_original_1464427238_PeerstPlayer_Icon_normal.png' }
    end

    describe '管理者の情報が取得できること', vcr: '#find-owners' do
      let (:dominion)  { event.owners.select { |user| user.twitter_id == 'Dominion525' }.first }
      it { expect(event.owners.count).to eq 1 }
      it { expect(dominion.twitter_id).to eq 'Dominion525' }
      it { expect(dominion.name).to eq 'どみにをん525' }
      it { expect(dominion.image_url).to eq 'https://graph.facebook.com/100001033554537/picture' }
    end
  end

  describe '#catch', vcr: '#catch' do
    let(:event) { api.find(event_id: 60104) }
    it 'キャッチコピーが取得できること' do
      expect(event.catch).to start_with '「Scratch Day &amp; Hour of Code in 豊橋」を全国のCoderDojoに合わせて開催します。今回はScratchやTickle（iPadを使用）、Scratch制御のリモコンカー等のワークショップを行います。'
    end
  end
end
