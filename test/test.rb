# encoding: utf-8
require 'test/unit'
require './app/connpass'
require './app/doorkeeper'
require './app/Atnd'

class ConnpassTest < Test::Unit::TestCase
  def test_search
    api = Connpass.new
    events = api.search('名古屋', 201611)
    assert(events.count > 0)
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
    # assert_equal('http://twitter.com/ytabuchi', event.owner_twitter_url)

    assert(event.users.count > 0)
    user = event.users.select {|user| user[:name] == 'シュール'}.first
    assert_equal(user[:id], 'https://connpass.com/user/shule517/')
    assert_equal(user[:name], 'シュール')
    assert_equal(user[:image], 'https://connpass-tokyo.s3.amazonaws.com/thumbs/b9/93/b99305b6784e742244868ddd5acc8646.png')
  end

  def test_doorkeeper
    api = Doorkeeper.new
    events = api.search('リモート開発 de ナイト', 201601)
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

    assert(event.users.count > 0)
    user = event.users.select {|user| user[:name] == 'シュール'}.first
    assert_equal(user[:id], 'シュール')
    assert_equal(user[:name], 'シュール')
    assert_equal(user[:image], 'https://dzpp79ucibp5a.cloudfront.net/users_avatar_files/295014_original_1464427238_PeerstPlayer_Icon_normal.png')
  end

  def test_atnd
    api = Atnd.new
    events = api.search('エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！')
    event = events.first
    assert_equal('エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！', event.title)
    #assert_equal('https://atnd.org/event_images/0008/0890/008_original.jpg?1474957731', event.logo)
    assert(event.catch.start_with?('【ATEAM TECHとは】'))
    assert_equal('2016-10-11T20:00:00.000+09:00', event.started_at)
    assert_equal('エイチーム　本社', event.place)
    assert_equal('〒450-6432　名古屋市中村区名駅三丁目28番12号　大名古屋ビルヂング 32F', event.address)
    #assert_equal('JXUG', event.group_title)
    #assert_equal(1134, event.group_id)
    #assert_equal('http://jxug.connpass.com/', event.group_url)
    assert_equal(false, event.limit_over?)
    #assert_equal('http://twitter.com/ytabuchi', event.owner_twitter_url)

    #users = api.event_users(event.event_id)
    #assert(users.count > 0)
    #assert(users.include?('http://connpass.com/user/shule517/'))
  end
end
