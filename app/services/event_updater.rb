class EventUpdater
  def self.call
    collector = EventCollector.new
    events = collector.search(['201612', '201701', '201702'])
    events.each do |event|
      puts event.title
      event_record = event.find_or_initialize_by
      puts "event:#{event.title}"

      event.owners.each do |user|
        puts "owner: #{user[:id]}"
        user_record = User.find_or_create_by(connpass_id: user[:id], twitter_id: user[:twitter_id], name: user[:name], image_url: user[:image])
        if !event_record.participant_users.exists?(user_record)
          event_record.participant_users << user_record
        end
      end

      event_record.participants.each do |participant|
        participant.owner = true
      end

      event.users.each do |user|
        puts "user: #{user[:id]}"
        user_record = User.find_or_create_by(connpass_id: user[:id], twitter_id: user[:twitter_id], name: user[:name], image_url: user[:image])
        if !event_record.participant_users.exists?(user_record)
          event_record.participant_users << user_record
        end
      end

      event_record.save
    end
  end
end
