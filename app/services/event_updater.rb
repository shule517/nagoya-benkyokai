# encoding: utf-8
class EventUpdater
  def self.call
    collector = EventCollector.new
    period = ["201701", "201702", "201703"]
    events = collector.search(period)
    events.each do |event|
      puts event.title
      event_record = event.find_or_initialize_by
      puts "event:#{event.title}"

      event.owners.each do |user|
        puts "owner: #{user.name}"
        user_record = user.find_or_create_by
        if !event_record.participant_users.exists?(user_record)
          event_record.participant_users << user_record
          event_record.participants.select{|participant| participant.user_id == user_record.id}.first.owner = true
        end
      end

      event.users.each do |user|
        puts "user: #{user.name}"
        user_record = user.find_or_create_by
        if !event_record.participant_users.exists?(user_record)
          event_record.participant_users << user_record
        end
      end

      event_record.save
    end
  end
end
