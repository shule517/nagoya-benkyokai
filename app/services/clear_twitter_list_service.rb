# 開催終了から一週間経ったイベントのツイッターリストを削除する
class ClearTwitterListService
  def call
    twitter = TwitterClient.new
    lists = twitter.lists
    events = Event.where('ended_at < ?', 7.day.ago)
    events.each do |event|
      list_name = event.twitter_list_name
      puts "delete #{list_name}"
      if lists.any? { |list| list[:name] == list_name }
        begin
          twitter.destroy_list(event.twitter_list_url)
        rescue => e
          puts e
        end
      end
    end
  end
end
