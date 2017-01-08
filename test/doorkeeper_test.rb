# encoding: utf-8
require 'test/unit'
require_relative '../app/doorkeeper'
require_relative './event_interface'

class DoorkeeperTest < Test::Unit::TestCase
  include EventInterfaceTest

  def setup
    api = Doorkeeper.new
    events = api.search(['リモート開発 de ナイト'], [201601])
    assert(events.count > 0)
    @event = events.first
  end

  def test_doorkeeper
    api = Doorkeeper.new
    events = api.search(['リモート開発 de ナイト'], [201601])
    event = events.first
    assert_equal('リモート開発 de ナイト ＠名古屋ギークバー', event.title)
    assert_equal('https://dzpp79ucibp5a.cloudfront.net/events_banners/45257_normal_1463562966_%E5%90%8D%E5%8F%A4%E5%B1%8B%E3%82%AE%E3%83%BC%E3%82%AF%E3%83%90%E3%83%BC%E3%83%AD%E3%82%B4.png', event.logo)
    assert_equal('2016-06-13T10:30:00.000Z', event.started_at)
    assert_equal('Club Adriana', event.place)
    assert_equal('名古屋市中区葵1-27-37シティハイツ1F', event.address)
    assert_equal('名古屋ギークバー', event.group_title)
    assert_equal(1995, event.group_id)
    assert_equal('https://geekbar.doorkeeper.jp/', event.group_url)
    assert_equal('https://dzpp79ucibp5a.cloudfront.net/groups_logos/1995_normal_1380975297_251035_156371434432231_4785187_n.jpg', event.group_logo)

    assert_equal(event.accepted, event.users.count + 3) # 3人アカウント非表示
    shule = event.users.select {|user| user.twitter_id == 'shule517'}.first
    assert_equal(shule.twitter_id, 'shule517')
    assert_equal(shule.name, 'シュール')
    assert_equal(shule.image_url, 'https://dzpp79ucibp5a.cloudfront.net/users_avatar_files/295014_original_1464427238_PeerstPlayer_Icon_normal.png')

    assert_equal(event.owners.count, 1)
    dominion = event.owners.select {|user| user.twitter_id == 'Dominion525'}.first
    assert_equal(dominion.twitter_id, 'Dominion525')
    assert_equal(dominion.name, 'どみにをん525')
    assert_equal(dominion.image_url, 'https://graph.facebook.com/100001033554537/picture')
  end

  def test_monodukuri_night
    api = Doorkeeper.new
    events = api.search(['ものづくりナイト@名古屋ギークバー'], [201612])
    event = events.first
    assert_equal("ものづくりナイト@名古屋ギークバー\n\nMakerFaireで大人気の”マーブルマシン”を制作している原田さんと、ワクワクする印刷工場を立ち上げた堀江さんをお招きして、ものづくりのコダワリを語っていただきます。\n\n名古屋ギークバー の2016年最終営業です。\n忘年会も兼ねてみんなでわいわいできると嬉しいです。\n\nモデレーター\n\nTakashi Matsuoka（MakerLabNagoya）\n\n\n\n小学生時代はラジコンとゲームの日々だったが、１０歳のときにパソコンに出会い、月刊誌に掲載されていたプログラムの打ち込みに没頭。\n高校時代はアマチュア無線と電子工作で電気の世界へ。\n得意技は、ハンダ付け。\n\nスピーカー\n\n原田直樹（マーブル職人）\n\n\n\n1965年名古屋生まれ。1982年からLEDバッジ、2008年からマーブルマシン、シンセサイザーなどの製作。またイベントに作品を多数出展。\n\n堀江賢司（堀江織物株式会社／happyprinters）\n\n\n\n愛知で布の印刷業である堀江織物株式会社でマーケティング部部長をしつつ、原宿でデジタルプリントに特化したものづくりスペースであるHappyPrintersを運営。\n2015年、１ｍから布がつくれるWEBサービスHappyFabric.meを立ち上げる。\n2017年1月、HappyPrintersの二号店を一宮にOPEN。\n\nタイムテーブル\n\n19:00       会場\n19:30-21:00 トークセッション\n21:00-22:00 展示\n\n名古屋ギークバーについて\n\n毎週月曜日 19:00- 名古屋・新栄のピアノバー「PIANO BAR club Adriana」さんをお借りして開催しています。\n入場料：1500円（本件イベントの参加費用によって充当されます\n\nソフトドリンク、スナック類は無料です。\nアルコール、フード類は有料（キャッシュオンデリバリ）です。\n電源、Wi-Fiは完備しています。", event.catch)
  end
end
