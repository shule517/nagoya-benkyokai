require_relative './twitter_client'
class DeleteTwitterList
  def self.call
    @twitter = TwitterClient.new
    time = Time.now
    time -= (24*60*60)*7 # 1週間前
    date = time.strftime("%Y-%m-%d")
    events = Event.where("ended_at < '#{date}'").select(:event_id)
    events.each do |event|
      @twitter.destroy_list(event.event_id)
    end
  end
end
