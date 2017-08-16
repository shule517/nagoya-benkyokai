class UpdateEventService
  def call(condition = {})
    condition.merge!(ym: collect_period) if condition.empty?
    events = SearchEventService.new.call(condition)
    update(events)
    UpdateTwitterService.new.call
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

  def update(events)
    events.each do |event|
      event_record = event.find_or_initialize_by
      puts "event:#{event.title}"

      event.owners.each do |user|
        puts "owner: #{user.name}"
        user_record = user.find_or_create_by
        unless event_record.participant_users.exists?(user_record)
          event_record.participant_users << user_record
          event_record.participants.select { |participant| participant.user_id == user_record.id }.first.owner = true
        end
      end

      event.users.each do |user|
        puts "user: #{user.name}"
        user_record = user.find_or_create_by
        unless event_record.participant_users.exists?(user_record)
          event_record.participant_users << user_record
        end
      end

      event_record.save
    end
  end
end
