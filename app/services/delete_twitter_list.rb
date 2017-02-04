require_relative './twitter_client'
class DeleteTwitterList
  def self.call
    @twitter = TwitterClient.new
    lists = @twitter.lists

    time = Time.now
    time -= (24 * 60 * 60) * 7 # 1週間前
    date = time.strftime('%Y-%m-%d')

    events = Event.where("ended_at < '#{date}'").select(:event_id)
    events.each do |event|
      puts event.event_id
      list_name = "nagoya-#{event.event_id}"
      if lists.any? { |list| list.name == list_name }
        @twitter.destroy_list(list_name)
      end
    end
  end
end
