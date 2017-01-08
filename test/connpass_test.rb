# encoding: utf-8
require 'test/unit'
require_relative '../app/connpass'
require_relative './event_interface'

class ConnpassTest < Test::Unit::TestCase
  include EventInterfaceTest

  def setup
    api = Connpass.new
    events = api.search(['名古屋'], [201611])
    assert(events.count > 0)
    @event = events.first
  end

  def test_connpass
    api = Connpass.new
    events = api.search(['JXUGC #14 Xamarin'])
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
    shule = event.users.select {|user| user.connpass_id == 'shule517'}.first
    assert_equal(shule.connpass_id, 'shule517')
    assert_equal(shule.twitter_id, 'shule517')
    assert_equal(shule.name, 'シュール')
    assert_equal(shule.image_url, 'https://connpass-tokyo.s3.amazonaws.com/thumbs/b9/93/b99305b6784e742244868ddd5acc8646.png')

    assert_equal(event.owners.count, 4)
    kuu = event.users.select {|user| user.connpass_id == 'Kuxumarin'}.first
    assert_equal(kuu.connpass_id, 'Kuxumarin')
    assert_equal(kuu.twitter_id, 'Fumiya_Kume')
    assert_equal(kuu.name, 'くう@牛奶茶')
    assert_equal(kuu.image_url, 'https://connpass-tokyo.s3.amazonaws.com/thumbs/75/1f/751ff2dde8d0e259e4ad95c77bcda057.png')
  end

  def test_users
    # group_urlがない場合
    api = Connpass.new
    events = api.search(['ちゅーんさんちでHaskellやると楽しいという会'])
    event = events.first
    users = event.users
    assert_equal(event.accepted, users.count)
    assert_equal(event.owners.count, 1)
  end

  def test_JPSPS
    # JPSPSが表示されない問題を解決
    api = Connpass.new
    events = api.search(['JPSPS'])
    event = events.first
    assert_equal('第5回 JPSPS SharePoint/Office365名古屋分科勉強会 at GeekBar', event.title)
  end
end
