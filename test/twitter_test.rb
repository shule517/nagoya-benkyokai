#encoding: utf-8
require 'test/unit'
require_relative '../app/twitter_client'

class TwitterTest < Test::Unit::TestCase
  def setup
    # api = Connpass.new
    # events = api.search('名古屋', [201611])
    # assert(events.count > 0)
    # @event = events.first
    @twitter = TwitterClient.new
  end

  def test_create_list
    @twitter.create_list('test', 'description1')
    assert(@twitter.list_exists?('test'))
    assert_equal('description1', @twitter.list('test')[:description])

    @twitter.create_list('test', 'description2')
    assert(@twitter.list_exists?('test'))
    assert_equal('description2', @twitter.list('test')[:description])

    @twitter.add_list_member('test', 'shule517')
    # puts @twitter.list_members('test')

    @twitter.destroy_list('test')
    assert(!@twitter.list_exists?('test'))
  end

  def test_list_exists
    assert(!@twitter.list_exists?('nagoya-99999'))
    assert(@twitter.list_exists?('nagoya-39118'))
  end
end
