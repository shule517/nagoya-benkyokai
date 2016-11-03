require 'test/unit'
require './connpass'

class ConnpassTest < Test::Unit::TestCase
  def test_event_users
    api = Connpass.new
    users = api.event_users(41648)
    assert(users.count > 0)
    assert(users.include?('http://connpass.com/user/shule517/'))
  end
end
