# イベント情報をDBへ登録する
class StoreEventService
  def call(event)
    store(event)
  end

  private

  def store(event)
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
    event_record
  end
end
