# encoding: utf-8
require 'test/unit'
require_relative '../app/connpass'
require_relative '../app/doorkeeper'
require_relative '../app/atnd'

module EventInterfaceTest
  def test_implements_interface
    assert_respond_to(@event, :event_id)
    assert_respond_to(@event, :title)
    assert_respond_to(@event, :catch)
    assert_respond_to(@event, :description)
    assert_respond_to(@event, :event_url)
    assert_respond_to(@event, :started_at)
    assert_respond_to(@event, :ended_at)
    assert_respond_to(@event, :url)
    assert_respond_to(@event, :address)
    assert_respond_to(@event, :place)
    assert_respond_to(@event, :lat)
    assert_respond_to(@event, :lon)
    assert_respond_to(@event, :limit)
    assert_respond_to(@event, :accepted)
    assert_respond_to(@event, :waiting)
    assert_respond_to(@event, :updated_at)
    assert_respond_to(@event, :hash_tag)
    assert_respond_to(@event, :place_enc)
    assert_respond_to(@event, :limit_over?)
    assert_respond_to(@event, :source)
    assert_respond_to(@event, :catch)
    assert_respond_to(@event, :group_url)
    assert_respond_to(@event, :group_id)
    assert_respond_to(@event, :group_title)
    assert_respond_to(@event, :group_logo)
    assert_respond_to(@event, :logo)
    assert_respond_to(@event, :users)
  end
end

class ConnpassTest < Test::Unit::TestCase
  include EventInterfaceTest

  def setup
    api = Connpass.new
    events = api.search('名古屋', [201611])
    assert(events.count > 0)
    @event = events.first
  end

  def test_connpass
    api = Connpass.new
    events = api.search('JXUGC #14 Xamarin')
    event = events.first
    assert_equal('JXUGC #14 Xamarin ハンズオン 名古屋大会', event.title)
    assert_equal('https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png', event.logo)
    assert(event.catch.start_with?('にゃごやでも話題の Xamarin を触ってみよう！'))
    assert_equal('2016-05-15T13:00:00+09:00', event.started_at)
    assert_equal('熱田生涯学習センター', event.place)
    assert_equal('熱田区熱田西町2-13', event.address)
    assert_equal('JXUG', event.group_title)
    assert_equal(1134, event.group_id)
    assert_equal('https://jxug.connpass.com/', event.group_url)
    assert_equal('https://connpass-tokyo.s3.amazonaws.com/thumbs/c9/d3/c9d379a73fa278df5fae314abd0d227a.png', event.group_logo)
    assert_equal(true, event.limit_over?)

    assert_equal(event.accepted, event.users.count)
    shule = event.users.select {|user| user[:id] == 'shule517'}.first
    assert_equal(shule[:id], 'shule517')
    assert_equal(shule[:twitter_id], 'shule517')
    assert_equal(shule[:name], 'シュール')
    assert_equal(shule[:image], 'https://connpass-tokyo.s3.amazonaws.com/thumbs/b9/93/b99305b6784e742244868ddd5acc8646.png')

    assert_equal(event.owners.count, 4)
    kuu = event.users.select {|user| user[:id] == 'Kuxumarin'}.first
    assert_equal(kuu[:id], 'Kuxumarin')
    assert_equal(kuu[:twitter_id], 'Fumiya_Kume')
    assert_equal(kuu[:name], 'くう@牛奶茶')
    assert_equal(kuu[:image], 'https://connpass-tokyo.s3.amazonaws.com/thumbs/75/1f/751ff2dde8d0e259e4ad95c77bcda057.png')
  end

  def test_users
    # group_urlがない場合
    api = Connpass.new
    events = api.search('ちゅーんさんちでHaskellやると楽しいという会')
    event = events.first
    users = event.users
    assert_equal(event.accepted, users.count)
    assert_equal(event.owners.count, 1)
  end
end

class DoorkeeperTest < Test::Unit::TestCase
  include EventInterfaceTest

  def setup
    api = Doorkeeper.new
    events = api.search('リモート開発 de ナイト', [201601])
    assert(events.count > 0)
    @event = events.first
  end

  def test_doorkeeper
    api = Doorkeeper.new
    events = api.search('リモート開発 de ナイト', [201601])
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
    shule = event.users.select {|user| user[:id] == 'shule517'}.first
    assert_equal(shule[:id], 'shule517')
    assert_equal(shule[:twitter_id], 'shule517')
    assert_equal(shule[:name], 'シュール')
    assert_equal(shule[:image], 'https://dzpp79ucibp5a.cloudfront.net/users_avatar_files/295014_original_1464427238_PeerstPlayer_Icon_normal.png')

    assert_equal(event.owners.count, 1)
    dominion = event.owners.select {|user| user[:id] == 'Dominion525'}.first
    assert_equal(dominion[:id], 'Dominion525')
    assert_equal(dominion[:twitter_id], 'Dominion525')
    assert_equal(dominion[:name], 'どみにをん525')
    assert_equal(dominion[:image], 'https://graph.facebook.com/100001033554537/picture')
  end
end

class AtndTest < Test::Unit::TestCase
  include EventInterfaceTest

  def setup
    api = Atnd.new
    events = api.search('エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！')
    assert(events.count > 0)
    @event = events.first
  end

  def test_atnd
    api = Atnd.new
    events = api.search('エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！')
    event = events.first
    assert_equal('エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！', event.title)
    assert(event.catch.start_with?('【ATEAM TECHとは】'))
    assert_equal('2016-10-11T20:00:00.000+09:00', event.started_at)
    assert_equal('エイチーム　本社', event.place)
    assert_equal('〒450-6432　名古屋市中村区名駅三丁目28番12号　大名古屋ビルヂング 32F', event.address)
    assert_equal(false, event.limit_over?)
  end
end
