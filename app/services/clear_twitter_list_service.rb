class ClearTwitterListService
  def call
    @twitter = TwitterClient.new
    @lists = twitter.lists
    delete
  end

  private
  attr_reader :twitter, :lists

  def delete
    target_events.each do |event|
      delete_list(event) if lists.any? { |list| list.name == event.twitter_list_name }
    end
  end

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
