# DBの情報を元にツイッターリストを更新する
class UpdateTwitterListService
  attr_reader :event, :twitter
  def call(event)
    @twitter = TwitterClient.new
    @event = event
    update_twitter_list
  end

  private

  def lists
    @@lists ||= twitter.lists
  end

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
