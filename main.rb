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
    events = api.search('名古屋')
    assert(events.count > 0)
  end
end
