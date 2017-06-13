class DeleteTwitterList
  def self.call
    @twitter = TwitterClient.new
    lists = twitter.lists
    target_events.each do |event|
      delete_list(event) if lists.any? { |list| list.name == event.twitter_list_name }
    end
  end

  private
  attr_reader :twitter

  def target_events
    Event.where('ended_at < ?', 1.month.ago) # 1ヶ月前
  end

  def delete_list(event)
    puts "delete #{event.twitter_list_name}"
    twitter.destroy_list(event.twitter_list_url)
  rescue => e
    puts e
  end
end
