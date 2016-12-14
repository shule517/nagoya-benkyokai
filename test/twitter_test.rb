#encoding: utf-8
require 'test/unit'
require_relative '../app/twitter_client'

class TwitterTest < Test::Unit::TestCase
  def setup
  #   api = Connpass.new
  #   events = api.search('名古屋', [201611])
  #   assert(events.count > 0)
  #   @event = events.first
    @twitter = TwitterClient.new
  end

  def test_create_list
    @twitter.create_list('test', 'description1')
    assert(@twitter.list_exists?('test'))

    @twitter.create_list('test', 'description2')
    assert(@twitter.list_exists?('test'))

    @twitter.destroy_list('test')
    assert(!@twitter.list_exists?('test'))
  end

  def test_list_exists
    assert(!@twitter.list_exists?('nagoya-99999'))
    assert(@twitter.list_exists?('nagoya-39118'))
  end


  # def test_add_twiter_list
  #   twitter = TwitterClient.new
  #   twitter.add_twitter_list(@event.event_id, @event.)
  # end
end