# DBの情報を元にツイッターリストを更新する
class UpdateTwitterListService
  def call
    twitter = TwitterClient.new
    lists = twitter.lists

    events = Event.all.where('started_at >= ?', Date.today.strftime).order(:started_at)
    events.each do |event|
      UpdateTwitterList.new.call(event, lists)
    end
  end
end

class UpdateTwitterList
  attr_reader :event, :lists, :twitter
  def call(event, lists)
    @twitter = TwitterClient.new
    @event = event
    @lists = lists
    update_twitter_list
  end

  private

  def update_twitter_list
    if lists.any? { |list| list[:uri] == event.twitter_list_url }
      update_list
    else
      create_list
    end
    twitter.add_list_member(event.twitter_list_url, unregistered_users) unless unregistered_users.empty?
  end

  def update_list
    puts "update list: #{description}"
    updated_list = twitter.update_list(event.twitter_list_url, event.title, description)
    old_list = lists.find { |list| list[:uri] == event.twitter_list_url }
    old_list = updated_list
    event.twitter_list_name = updated_list.name
    event.twitter_list_url = updated_list.uri
    event.save
  end

  def create_list
    puts "crate list: #{description}"
    created_list = twitter.create_list(event.title, description)
    lists << created_list
    event.twitter_list_name = created_list.name
    event.twitter_list_url = created_list.uri
    event.save
  rescue => e
    Slack.chat_postMessage text: "title: #{event.title}", channel: '#test-error', username: 'lambda'
    Slack.chat_postMessage text: "description: #{description}", channel: '#test-error', username: 'lambda'

    message = local_variables.map { |v|
      name = v.to_s
      value = eval("#{v}")
      "#{name}: #{value}"
    }.join("¥n")
    Slack.chat_postMessage text: message, channel: '#test-error', username: 'lambda'
    throw
  end

  def description
    "#{event.year}/#{event.month}/#{event.day}(#{event.wday}) #{event.title}"
  end

  def unregistered_users
    users = [*event.owners, *event.users]
    event_users = users.map { |user| user.twitter_id }.select { |id| id.present? }
    list_members = twitter.list_members(event.twitter_list_url).map { |member| member.screen_name }
    unregistered_users = event_users.select { |user| !list_members.include?(user) }
  end
end
