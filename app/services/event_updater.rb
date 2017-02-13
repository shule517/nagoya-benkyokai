class EventUpdater
  class << self
    def call
      collector = EventCollector.new
      events = collector.search(collect_period)
      update_db(events)

      @twitter = TwitterClient.new
      lists = @twitter.lists

      today = Time.now.strftime('%Y-%m-%d')
      events = Event.all.where(['started_at > ?', today]).order(:started_at)
      events.each do |event|
        update_event_to_twitter(event, lists)
      end
    end

    def update(yyyymm)
      collector = EventCollector.new
      events = collector.search([yyyymm])
      update_db(events)
    end

  private
    def collect_period
      now = Time.now
      day = 24 * 60 * 60
      month = 30 * day

      period = []
      period << (now).strftime('%Y%m')
      period << (now + 1 * month).strftime('%Y%m')
      period << (now + 2 * month).strftime('%Y%m')
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
            event_record.participants.select { |participant| participant.user_id == user_record.id }.first.owner = true
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

      if lists.any? { |list| list.uri.to_s == event.twitter_list_url } || @twitter.list_exists?(event.twitter_list_url)
        puts "update list: #{description}"
        list = @twitter.update_list(event.twitter_list_url, event.title, description)
        event.twitter_list_name = list.name
        event.twitter_list_url = list.uri
        event.save
      else
        puts "crate list: #{description}"
        list = @twitter.create_list(event.title, description)
        event.twitter_list_name = list.name
        event.twitter_list_url = list.uri
        event.save
      end

      users = []
      users.concat(event.owners)
      users.concat(event.users)
      event_users = users.map { |user| user.twitter_id }.select { |id| !id.empty? }
      twitter_members = @twitter.list_members(event.twitter_list_url).map { |member| member.screen_name }
      add_users = event_users.select { |user| !twitter_members.include?(user) }
      @twitter.add_list_members(event.twitter_list_url, add_users)
    end
  end
end
