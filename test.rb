# encoding: utf-8
require 'test/unit'
require './connpass'
require './doorkeeper'

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
    assert_equal('にゃごやでも話題の Xamarin を触ってみよう！', event.catch)
    assert_equal('熱田生涯学習センター', event.place)
    assert_equal('JXUG', event.group_title)
    assert_equal(1134, event.group_id)
    assert_equal('http://jxug.connpass.com/', event.group_url)
    assert_equal(true, event.limit_over?)
    assert_equal('http://twitter.com/ytabuchi', event.owner_twitter_url)

    users = api.event_users(event.event_id)
    assert(users.count > 0)
    assert(users.include?('http://connpass.com/user/shule517/'))
  end

  def test_doorkeeper
    api = Doorkeeper.new
    events = api.search('リモート開発 de ナイト')
    event = events.first
    assert_equal('リモート開発 de ナイト ＠名古屋ギークバー', event.title)
    assert_equal('https://dzpp79ucibp5a.cloudfront.net/events_banners/45257_normal_1463562966_%E5%90%8D%E5%8F%A4%E5%B1%8B%E3%82%AE%E3%83%BC%E3%82%AF%E3%83%90%E3%83%BC%E3%83%AD%E3%82%B4.png', event.logo)
    assert_equal('Club Adriana', event.place)
    assert_equal('名古屋ギークバー', event.group_title)
    assert_equal(1995, event.group_id)
    assert_equal('https://geekbar.doorkeeper.jp/', event.group_url)
    assert_equal('https://dzpp79ucibp5a.cloudfront.net/groups_logos/1995_normal_1380975297_251035_156371434432231_4785187_n.jpg', event.group_logo)

    users = api.event_users(event.event_id)
    assert(users.count > 0)
    assert(users.include?('シュール'))
  end
end
