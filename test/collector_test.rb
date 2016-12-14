#encoding: utf-8
require 'test/unit'
require_relative '../app/event_collector'

class EventCollectorTest < Test::Unit::TestCase
  def setup
    @collect = EventCollector.new
  end

  def test_event
    @collect.update_twitter([201612, 201701, 201702])
  end
end
