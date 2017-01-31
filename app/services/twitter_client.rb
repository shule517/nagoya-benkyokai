#encoding: utf-8
require "twitter"
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
    begin
      list(list_id)
      return true
    rescue Twitter::Error::NotFound
      return false
    end
  end

  def create_list(event_id, description)
    puts "create_list(#{event_id}, #{description})"
    begin
      if !list_exists?(event_id)
        @client.create_list(event_id, description: description[0...100])
      else
        @client.list_update(event_id, description: description[0...100])
      end
    rescue Twitter::Error::Forbidden => e
      puts "#{e}\nevent_id:#{event_id} description:#{description}"
    end
  end

  def destroy_list(event_id)
    puts "destroy_list(#{event_id})"
    if list_exists?(event_id)
      @client.destroy_list(event_id)
    end
  end

  def add_list_member(list_id, user_id)
    puts "add_list_member(#{list_id}, #{user_id})"
    begin
      @client.add_list_member(list_id, user_id)
    rescue Twitter::Error::Forbidden
      puts "Error: #{user_id}をリストに追加する権限がありません。"
    end
  end

  def list(list_id)
    puts "list(#{list_id})"
    @client.list(list_id)
  end

  def list_members(list_id)
    puts "list_members(#{list_id})"
    begin
      @client.list_members(list_id)
    rescue => e
      p e
      []
    end
  end

  def tweet(message)
    @client.update(message)
  end
end
