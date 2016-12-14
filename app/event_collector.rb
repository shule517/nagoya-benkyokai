#encoding: utf-8
require_relative './connpass'
require_relative './doorkeeper'
require_relative './atnd'
require_relative 'twitter_client'

class EventCollector
  def initialize
    @twitter = TwitterClient.new
  end

  def search(date)
    apis = []
    apis << Connpass.new
    apis << Doorkeeper.new
    events = []
    apis.each do |api|
      events += api.search('名古屋', date)
    end

    atnd_events = Atnd.new.search('名古屋', date)
    ngwords = ["仏教", "クリスマスパーティ", "テロリスト", "国際交流パーティ", "社会人基礎力"]
    atnd_events.select! {|event| ngwords.all? {|ngword| !event.title.include?(ngword)} }
    events += atnd_events

    places = ['愛知', '名古屋', '豊橋']
    events.select! {|event| places.any? {|place| event.address.include?(place)}}
    today = Time.now.strftime("%Y-%m-%d")
    puts "today:#{today}"
    events.select! {|event| event.started_at >= today}
    events.sort_by! {|event| event.started_at}
  end

  def update_twitter(date)
    events = search(date)
    events.each do |event|
      update_event_to_twitter(event)
    end
  end

  def update_event_to_twitter(event)
    description = "#{event.year}/#{event.month}/#{event.day}(#{event.wday}) #{event.title} #{event.url}"
    @twitter.create_list(event.twitter_list_id, description)

    users = []
    users.concat(event.owners)
    users.concat(event.users)
    event_users = users.map {|user| user[:twitter_id]}.select {|id| !id.empty?}
    twitter_members = @twitter.list_members(event.twitter_list_id).map {|member| member[:screen_name]}
    add_users = event_users.select {|user| !twitter_members.include?(user)}

    add_users.each do |twitter_id|
      @twitter.add_list_member(event.twitter_list_id, twitter_id)
    end
  end
end
