# 開催終了から一週間経ったイベントのツイッターリストを削除する
class ClearTwitterListService
  attr_reader :twitter, :lists
  def call
    @twitter = TwitterClient.new
    @lists = twitter.lists
    clear
  end

  private

  def clear
    target_events.each do |event|
      delete_list(event) if exists?(event)
    end
  end

  def target_events
    Event.where('ended_at < ?', 7.day.ago)
  end

  def delete_list(event)
    puts "delete #{event.twitter_list_name}"
    twitter.destroy_list(event.twitter_list_url)
  rescue => e
    puts e
  end

  def exists?(event)
    lists.any? { |list| list[:name] == event.twitter_list_name }
  end
end
