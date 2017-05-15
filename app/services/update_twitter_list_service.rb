# DBの情報を元にツイッターリストを更新する
class UpdateTwitterListService
  attr_reader :twitter, :lists
  def call
    @twitter = TwitterClient.new
    @lists = twitter.lists

    today = Date.today.strftime
    events = Event.all.where('started_at >= ?', today).order(:started_at)
    events.each do |event|
      update_twitter_list(event)
    end
  end

  private

  def update_twitter_list(event)
    description = "#{event.year}/#{event.month}/#{event.day}(#{event.wday}) #{event.title}"

    if lists.any? { |list| list[:uri] == event.twitter_list_url } || event.twitter_list_url && twitter.list_exists?(event.twitter_list_url)
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

    users = [*event.owners, *event.users]
    event_users = users.map { |user| user.twitter_id }.select { |id| !id.empty? }
    twitter_members = twitter.list_members(event.twitter_list_url).map { |member| member.screen_name }
    add_users = event_users.select { |user| !twitter_members.include?(user) }
    twitter.add_list_member(event.twitter_list_url, add_users)
  end
end
