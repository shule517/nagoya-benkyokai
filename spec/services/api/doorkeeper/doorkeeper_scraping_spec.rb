require 'rails_helper'
include Api::Doorkeeper
describe DoorkeeperScraping do
  let(:api) { DoorkeeperApi.new }
  describe 'リモート開発 de ナイト' do
    let(:event) { api.find(keyword: 'リモート開発 de ナイト', ym: '201606') }
    it { expect(event.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー' }
    it { expect(event.logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/events_banners/45257_normal_1463562966_%E5%90%8D%E5%8F%A4%E5%B1%8B%E3%82%AE%E3%83%BC%E3%82%AF%E3%83%90%E3%83%BC%E3%83%AD%E3%82%B4.png' }
    it { expect(event.started_at).to eq Date.parse('2016-06-13T10:30:00.000Z') }
    it { expect(event.place).to eq 'Club Adriana' }
    it { expect(event.address).to eq '名古屋市中区葵1-27-37シティハイツ1F' }
    it { expect(event.group_title).to eq '名古屋ギークバー' }
    it { expect(event.group_id).to eq 1995 }
    it { expect(event.group_url).to eq 'https://geekbar.doorkeeper.jp/' }
    it { expect(event.group_logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/groups_logos/1995_normal_1380975297_251035_156371434432231_4785187_n.jpg' }

    describe '参加者情報が取得できること' do
      let(:shule) { event.users.select { |user| user.twitter_id == 'shule517' }.first }
      it {
        expect(event.users.count + 3).to eq event.accepted # 3人アカウント非表示
        expect(shule.twitter_id).to eq 'shule517'
        expect(shule.name).to eq 'シュール'
        expect(shule.image_url).to eq 'https://dzpp79ucibp5a.cloudfront.net/users_avatar_files/295014_original_1464427238_PeerstPlayer_Icon_normal.png'
      }
    end

    describe '管理者情報が取得できること' do
      let (:dominion)  { event.owners.select { |user| user.twitter_id == 'Dominion525' }.first }
      it {
        expect(event.owners.count).to eq 1
        expect(dominion.twitter_id).to eq 'Dominion525'
        expect(dominion.name).to eq 'どみにをん525'
        expect(dominion.image_url).to eq 'https://graph.facebook.com/100001033554537/picture'
      }
    end
  end
end
