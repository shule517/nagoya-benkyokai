# encoding: utf-8
class EventUpdater
  class << self
    def call
      collector = EventCollector.new
      events = collector.search(collect_period)
      @twitter = TwitterClient.new
      update_db(events)

      lists = @twitter.lists
      events.each do |event|
        update_event_to_twitter(event, lists)
      end
    end

    private
    def collect_period
      now = Time.now
      day = 24*60*60
      month = 30*day

      period = []
      period << (now).strftime("%Y%m")
      period << (now + 1*month).strftime("%Y%m")
      period << (now + 2*month).strftime("%Y%m")
    end

    def update_db(events)
      events.each do |event|
        event_record = event.find_or_initialize_by
        puts "event:#{event.title}"

        event.owners.each do |user|
          puts "owner: #{user.name}"
          user_record = user.find_or_create_by
          if !event_record.participant_users.exists?(user_record)
            event_record.participant_users << user_record
            event_record.participants.select{ |participant| participant.user_id == user_record.id }.first.owner = true
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

    def update_event_to_twitter(event, lists)
      description = "#{event.year}/#{event.month}/#{event.day}(#{event.wday}) #{event.title} #{event.url}"

      if !lists.any?{ |list| list.name == event.twitter_list_id }
        puts "crate list: #{description}"
        @twitter.create_list(event.twitter_list_id, description)
      else
        puts "not crate list: #{description}"
      end

      users = []
      users.concat(event.owners)
      users.concat(event.users)
      event_users = users.map { |user| user.twitter_id}.select { |id| !id.empty? }
      twitter_members = @twitter.list_members(event.twitter_list_id).map { |member| member.screen_name }
      add_users = event_users.select { |user| !twitter_members.include?(user) }

      add_users.each do |twitter_id|
        @twitter.add_list_member(event.twitter_list_id, twitter_id)
      end
    end
  end
end
