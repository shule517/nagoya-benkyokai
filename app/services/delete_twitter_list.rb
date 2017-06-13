class DeleteTwitterList
  def self.call
    twitter = TwitterClient.new
    lists = twitter.lists

    time = Time.now
    time -= (24 * 60 * 60) * 30 # 30日前
    date = time.strftime('%Y-%m-%d')

    events = Event.where("ended_at < '#{date}'")
    events.each do |event|
      puts "delete #{event.twitter_list_name}"
      if lists.any? { |list| list.name == event.twitter_list_name }
        begin
          twitter.destroy_list(event.twitter_list_url)
        rescue => e
          puts e
        end
      end
    end
  end
end
