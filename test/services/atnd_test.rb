require 'test/unit'
require './app/services/atnd'
require './app/services/http'
require_relative './event_interface'

class AtndTest < Test::Unit::TestCase
  include EventInterfaceTest

  def setup
    api = Atnd.new
    events = api.search(['エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！'])
    assert(events.count > 0)
    @event = events.first
  end

  def test_atnd
    api = Atnd.new
    events = api.search(['エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！'])
    event = events.first
    assert_equal('エイチームの開発勉強会『ATEAM TECH』を10/11(火) に名古屋で開催！成長し続けるWebサービスの裏側 AWS活用事例を大公開！', event.title)
    assert(event.catch.start_with?('【ATEAM TECHとは】'))
    assert_equal('2016-10-11T20:00:00.000+09:00', event.started_at)
    assert_equal('エイチーム　本社', event.place)
    assert_equal('〒450-6432　名古屋市中村区名駅三丁目28番12号　大名古屋ビルヂング 32F', event.address)
    assert_equal(false, event.limit_over?)
    assert_equal('https://atnd.org/event_images/0008/0890/008_original.jpg?1474957731', event.logo)
  end
end
