require 'twitter'
require_relative './event_collector'

class TwitterClient
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def client
    @client
  end

  def lists
    @client.lists
  end

  def list_exists?(list_id)
    puts "list_exists?(#{list_id})"
    list(list_id)
    return true
  rescue Twitter::Error::NotFound
    return false
  end

  def create_list(event_id, description)
    puts "create_list(#{event_id}, #{description})"
    if !list_exists?(event_id)
      debug_mode = ENV['TWITTER_DEBUG_MODE']
      if debug_mode.nil? || !debug_mode
        @client.create_list(event_id, description: description[0...100], mode: 'private')
      else
        @client.create_list(event_id, description: description[0...100], mode: 'public')
      end
    else
      @client.list_update(event_id, description: description[0...100])
    end
  rescue Twitter::Error::Forbidden => e
    puts "#{e}\nevent_id:#{event_id} description:#{description}"
  end

  def destroy_list(event_id)
    if list_exists?(event_id)
      puts "destroy_list(#{event_id})"
      @client.destroy_list(event_id)
    end
  end

  def add_list_member(list_id, user_id)
    puts "add_list_member(#{list_id}, #{user_id})"
    @client.add_list_member(list_id, user_id)
  rescue Twitter::Error::Forbidden
    puts "Error: #{user_id}をリストに追加する権限がありません。"
  end

  def list(list_id)
    puts "list(#{list_id})"
    @client.list(list_id)
  end

  def list_members(list_id)
    puts "list_members(#{list_id})"
    @client.list_members(list_id)
  rescue => e
    p e
    []
  end

  def tweet(message)
    @client.update(message)
  end
end
