# encoding: utf-8
require 'test/unit'
require './connpass'

class ConnpassTest < Test::Unit::TestCase
  def test_event_users
    api = Connpass.new
    users = api.event_users(41648)
    assert(users.count > 0)
    assert(users.include?('http://connpass.com/user/shule517/'))
  end

  def test_search
    api = Connpass.new
    events = api.search('名古屋', 201611)
    assert(events.count > 0)
  end

  def test_event
    api = Connpass.new
    events = api.search('JXUGC #14 Xamarin ハンズオン 名古屋大会')
    event = events.first
    assert_equal('JXUG', event.group_title)
    assert_equal(1134, event.group_id)
    assert_equal('http://jxug.connpass.com/', event.group_url)
    assert_equal('https://connpass-tokyo.s3.amazonaws.com/thumbs/d7/3c/d73cccc993bb52bffbc0b65bc4c10d38.png', event.image)
    assert_equal(true, event.limit_over?)
    assert_equal('http://twitter.com/ytabuchi', event.owner_twitter_url)
  end
end
