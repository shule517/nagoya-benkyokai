class DeleteTwitterList
  def self.call
    @twitter = TwitterClient.new
    lists = @twitter.lists

    time = Time.now
    time -= (24 * 60 * 60) * 7 # 1週間前
    date = time.strftime('%Y-%m-%d')

    events = Event.where("ended_at < '#{date}'").select(:twitter_list_name)
    events.each do |event|
      list_name = event.twitter_list_name
      puts "delete #{list_name}"
      if lists.any? { |list| list.name == list_name }
        @twitter.destroy_list(list_name)
      end
    end
  end
end
