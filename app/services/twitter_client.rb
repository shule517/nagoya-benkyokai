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

  def lists(option = {})
    lists = []
    next_cursor = -1
    4.times.flat_map {
      owned_lists = @client.owned_lists(cursor: next_cursor, count: 250)
      next_cursor = owned_lists.attrs[:next_cursor]
      p next_cursor
      lists = [*lists, *owned_lists.attrs[:lists]]
      break if next_cursor == 0
    }
    lists
  end

  def list_exists?(list_id)
    puts "list_exists?(#{list_id})"
    list(list_id)
    return true
  rescue Twitter::Error::NotFound
    return false
  end

  def mode
    @mode ||= begin
      debug_mode = ENV['TWITTER_DEBUG_MODE']
      if debug_mode == 'false'
        'public'
      else
        'private'
      end
    end
  end

  def check_list_name(title)
    return false if title.size > 25
    return false if title.bytesize > 55
    return false if title =~ (/\A[0-9]/)
    return true
  end

  def trim(str)
    str.gsub(/\bin$/, '').gsub(/[・【「\[（(＠@～:：\. ]+$/, '').strip
  end

  def create_list_name(title)
    title.strip!
    title.gsub!(/twitter/i, 'ツイッター')
    title.gsub!(/[[:space:]]+/, ' ')
    title.gsub!(/[\/]+/, '/')
    title.gsub!(/[:]+/, '')
    if title =~ /^[0-9]/
      title = '-' + title
    end
    words = title.split(/\b/)
    name = ''
    words.each do |word|
      if check_list_name(name + word)
        name += word
      else
        break
      end
    end
    if name.length <= 3
      title[name.length..(title.length - name.length)].each_char do |char|
        if check_list_name(name + char)
          name += char
        else
          return trim(name)
        end
      end
    end
    trim(name)
  end

  def check_list_desc(desc)
    return false if desc.size > 100
    return false if desc.bytesize > 255
    return true
  end

  def create_list_desc(desc)
    desc.gsub(/[[:space:]]+/, ' ')
    words = desc.split(/\b/)
    name = ''
    words.each do |word|
      if check_list_desc(name + word)
        name += word
      else
        break
      end
    end
    if name.empty?
      desc.each_char do |char|
        if check_list_desc(name + char)
          name += char
        else
          return name
        end
      end
    end
    name
  end

  def create_list(title, description)
    title = create_list_name(title)
    description = create_list_desc(description)
    puts "create_list(title:#{title}, description:#{description})"
    @client.create_list(title, description: description, mode: mode)
  rescue Twitter::Error::Forbidden => e
    puts "#{e}\ntitle:#{title} description:#{description}"
  end

  def update_list(uri, title, description)
    list_name = create_list_name(title)
    description = create_list_desc(description)
    puts "update_list(uri:#{uri}, list_name:#{list_name}, description:#{description})"
    @client.list_update(uri, name: list_name, description: description, mode: mode)
  rescue Twitter::Error::Forbidden => e
    puts "#{e}\nuri:#{uri} list_name:#{list_name} description:#{description}"
  rescue => e
    puts "#{e}\nuri:#{uri} list_name:#{list_name} description:#{description}"
  end

  def destroy_list(event_id)
    puts "destroy_list(#{event_id})"
    @client.destroy_list(event_id)
  end

  def add_list_member(list_id, user_id)
    puts "add_list_member(#{list_id}, #{user_id})"
    case user_id
    when String
      @client.add_list_member(list_id, user_id)
    when Array
      return if user_id.empty?
      @client.add_list_members(list_id, user_id)
    end
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
