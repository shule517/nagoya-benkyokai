class UpdateTwitterService
  def initialize
    @twitter = TwitterClient.new
    @lists = twitter.lists
  end

  def call(events)
    events.each do |event|
      update_event_to_twitter(event)
    end
  end

  private
  attr_reader :twitter, :lists
  def update_event_to_twitter(event)
    description = "#{event.year}/#{event.month}/#{event.day}(#{event.wday}) #{event.title} #{event.event_url}"

    if lists.any? { |list| list.uri.to_s == event.twitter_list_url } || (event.twitter_list_url && twitter.list_exists?(event.twitter_list_url))
      puts "update list: #{description}"
      list = twitter.update_list(event.twitter_list_url, event.title, description)
      event.twitter_list_name = list.name
      event.twitter_list_url = list.uri
      event.save
    else
      puts "crate list: #{description}"
      list = twitter.create_list(event.title, description)
      event.twitter_list_name = list.name
      event.twitter_list_url = list.uri
      event.save
    end

    users = []
    users.concat(event.owners)
    users.concat(event.users)
    event_users = users.map { |user| user.twitter_id }.select { |id| !id.empty? }
    twitter_members = twitter.list_members(event.twitter_list_url).map { |member| member.screen_name }
    add_users = event_users.select { |user| !twitter_members.include?(user) }
    twitter.add_list_members(event.twitter_list_url, add_users)
  end
end
