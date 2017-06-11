require 'rails_helper'
include Api::Doorkeeper

describe DoorkeeperEvent, type: :request do
# describe DoorkeeperScraping, type: :request do
  let(:api) { Doorkeeper.new }
  # let(:api) { DoorkeeperApi }
  describe '#find' do
    # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
    let(:event) { api.find(event_id: 45257) }
    example 'イベントが取得できること', vcr: '#find' do
      expect(event.source).to eq 'doorkeeper'
      # expect(event.source).to eq 'Doorkeeper'
      expect(event.event_id).to eq 45257
      expect(event.event_url).to eq 'https://geekbar.doorkeeper.jp/events/45257'
      expect(event.url).to eq nil # ATNDのみ参考URLが設定される
      expect(event.title).to eq 'リモート開発 de ナイト ＠名古屋ギークバー'
      expect(event.catch).to start_with "リモート開発、してますか？\nしている人も、していないけどしたい人も、集まって情報交換しましょう。"
      expect(event.description).to start_with "<p>リモート開発、してますか？<br><br>\nしている人も、していないけどしたい人も、集まって情報交換しましょう。"
      expect(event.logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/events_banners/45257_normal_1463562966_%E5%90%8D%E5%8F%A4%E5%B1%8B%E3%82%AE%E3%83%BC%E3%82%AF%E3%83%90%E3%83%BC%E3%83%AD%E3%82%B4.png'
      expect(event.started_at).to eq '2016-06-13T10:30:00.000Z'
      # expect(event.started_at).to eq Time.parse('2016-06-13T10:30:00.000Z')
      expect(event.ended_at).to eq '2016-06-13T13:00:00.000Z'
      # expect(event.ended_at).to eq Time.parse('2016-06-13 13:00:00.000000000 +0000')
      expect(event.place).to eq 'Club Adriana'
      expect(event.lat).to eq '35.170239'
      expect(event.lon).to eq '136.92266159999997'
      expect(event.limit).to eq 38
      expect(event.accepted).to eq 32
      expect(event.waiting).to eq 0
      expect(event.updated_at).to eq '2017-01-10T12:14:06.478Z'
      # expect(event.updated_at).to eq '2017-01-10 12:14:06.478000000 +0000'
      expect(event.update_time).to eq '2017-01-10T12:14:06.478Z'
      # expect(event.update_time).to eq '2017-01-10 12:14:06.478000000 +0000'
      expect(event.hash_tag).to eq nil # Doorkeeperにはハッシュタグは設定されない
      expect(event.limit_over?).to eq false
      expect(event.users.count + 3).to eq event.accepted # 3人非表示
      expect(event.owners.count).to eq 1
      expect(event.address).to eq '名古屋市中区葵1-27-37シティハイツ1F'
      expect(event.group_id).to eq 1995
      expect(event.group_title).to eq '名古屋ギークバー'
      expect(event.group_url).to eq 'https://geekbar.doorkeeper.jp/'
      expect(event.group_logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/groups_logos/1995_normal_1380975297_251035_156371434432231_4785187_n.jpg'
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
    let(:users) { event.users }
    describe '参加者の情報が取得できること', vcr: '#user' do
      # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
      let(:event) { api.find(event_id: 45257) }
      let(:user) { users.select { |user| user.twitter_id == 'shule517' }.first }
      it { expect(user.twitter_id).to eq 'shule517' }
      it { expect(user.name).to eq 'シュール' }
      it { expect(user.image_url).to eq 'https://dzpp79ucibp5a.cloudfront.net/users_avatar_files/295014_original_1464427238_PeerstPlayer_Icon_normal.png' }
    end
    describe '#get_social_id' do
      context '全てのSNSが登録されているユーザの場合', vcr: '#user-sns-exist' do
        # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
        let(:event) { api.find(event_id: 45257) }
        let(:user) { event.users.select { |user| user.twitter_id == 'kekyo2' }.first }
        it { expect(user.twitter_id).to eq 'kekyo2' }
        it { expect(user.facebook_id).to eq '100004903747736' }
        it { expect(user.github_id).to eq 'kekyo' }
        it { expect(user.linkedin_id).to eq 'kouji-matsui-71856762' }
        it { expect(user.name).to eq 'kekyo' }
        it { expect(user.image_url).to eq 'https://dzpp79ucibp5a.cloudfront.net/users_avatar_files/64317_original_1484359298_github128.png' }
      end

      context 'linkedin_idのフォーマットが違う場合', vcr: '#user-sns-linkedin' do
        # 【サイト制作者向けアンカンファレンス】ECサイト制作の復習と予習をしよう！ | EC-CUBE名古屋 vol.42 https://ec-cube-nagoya.doorkeeper.jp/events/59752
        let(:event) { api.find(event_id: 59752) }
        let(:user) { event.users.select { |user| user.twitter_id == 'hydra55' }.first }
        it { expect(user.linkedin_id).to eq 'hiroyasu-yamada' }
      end

      context 'SNSが未登録なユーザの場合', vcr: '#user-sns-not_exist' do
        # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
        let(:event) { api.find(event_id: 45257) }
        let(:user) { event.users.select { |user| user.name == 'Tomoki Sakamiya' }.first }
        it { expect(user.atnd_id).to eq '' } # TODO nil
        it { expect(user.twitter_id).to eq '' } # TODO nil
        it { expect(user.facebook_id).to eq '' } # TODO nil
        it { expect(user.github_id).to eq '' } # TODO nil
        it { expect(user.linkedin_id).to eq '' } # TODO nil
        it { expect(user.name).to eq 'Tomoki Sakamiya' }
        it { expect(user.image_url).to eq 'https://secure.gravatar.com/avatar/c7102e2634db160be9f59a0029b867b7?s=25&d=mm' }
      end
    end
  end

  describe '#owners' do
    let(:owners) { event.owners }
    describe '管理者の情報が取得できること', vcr: '#owners-exist' do
      # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
      let(:event) { api.find(event_id: 45257) }
      it { expect(owners.count).to eq 1 }
    end
    context '管理者がいない場合', vcr: '#owners-not_exist' do
      # 5月26日（金）個別相談会 ＜朝の部＞ https://jimdocafe-hakata.doorkeeper.jp/events/60351
      let(:event) { api.find(event_id: 60351) }
      it { expect(owners.count).to eq 0 }
    end
  end

  describe '#owner' do
    let(:owners) { event.owners }
    describe '管理者の情報が取得できること', vcr: '#owner' do
      # リモート開発 de ナイト ＠名古屋ギークバー https://geekbar.doorkeeper.jp/events/45257
      let(:event) { api.find(event_id: 45257) }
      let (:owner)  { owners.select { |user| user.twitter_id == 'Dominion525' }.first }
      it { expect(owner.twitter_id).to eq 'Dominion525' }
      it { expect(owner.name).to eq 'どみにをん525' }
      it { expect(owner.image_url).to eq 'https://graph.facebook.com/100001033554537/picture' }
    end
    describe '#get_social_id' do
      context '全てのSNSが登録されている主催者の場合', vcr: '#owner-sns-exist' do
        #【サイト制作者向けアンカンファレンス】ECサイト制作の復習と予習をしよう！ | EC-CUBE名古屋 vol.42 https://ec-cube-nagoya.doorkeeper.jp/events/59752
        let(:event) { api.find(event_id: 59752) }
        let(:owner) { owners.select { |owner| owner.twitter_id == 'nanasess' }.first }
        it { expect(owner.twitter_id).to eq 'nanasess' }
        it { expect(owner.facebook_id).to eq '100001004509971' }
        it { expect(owner.github_id).to eq 'nanasess' }
        it { expect(owner.linkedin_id).to eq 'kentaro-ohkouchi' }
        it { expect(owner.name).to eq 'Kentaro Ohkouchi' }
        it { expect(owner.image_url).to eq 'https://graph.facebook.com/100001004509971/picture' }
      end

      context 'SNSが未登録な主催者の場合', vcr: '#owner-sns-not_exist' do
        # 【初開催】Startup Weekend 岡崎【プレイベント】 https://swokazaki.doorkeeper.jp/events/60330
        let(:event) { api.find(event_id: 60330) }
        let(:owner) { owners.select { |owner| owner.name == 'Startup Weekend Japan' }.first }
        it { expect(owner.atnd_id).to eq '' } # TODO nil
        it { expect(owner.twitter_id).to eq '' } # TODO nil
        it { expect(owner.facebook_id).to eq '' } # TODO nil
        it { expect(owner.github_id).to eq '' } # TODO nil
        it { expect(owner.linkedin_id).to eq '' } # TODO nil
        it { expect(owner.name).to eq 'Startup Weekend Japan' }
        it { expect(owner.image_url).to eq 'https://dzpp79ucibp5a.cloudfront.net/users_avatar_files/324974_original_1491355581_1835_normal_1377595229_SW_kauffman_bw.png' }
      end
    end
  end

  describe '#catch', vcr: '#catch' do
    let(:event) { api.find(event_id: 60104) }
    it 'キャッチコピーが取得できること' do
      expect(event.catch).to start_with '「Scratch Day &amp; Hour of Code in 豊橋」を全国のCoderDojoに合わせて開催します。今回はScratchやTickle（iPadを使用）、Scratch制御のリモコンカー等のワークショップを行います。'
    end
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
      # 5月26日（金）個別相談会 ＜朝の部＞ https://jimdocafe-hakata.doorkeeper.jp/events/60351
      let(:event) { api.find(event_id: 60351) }
      it { expect(event.group_logo).to eq 'https://dzpp79ucibp5a.cloudfront.net/assets/doorkeeper_group_normal-125b448b722fa8c158516cf4b86aafda26b442af55a001418b0eb2acf7117961.gif' }
    end
  end
end
