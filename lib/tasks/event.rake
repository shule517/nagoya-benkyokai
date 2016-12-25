# encoding: utf-8
namespace :event do
  desc "イベント情報を収集"
  task :update => :environment do
    collector = EventCollector.new
    events = collector.search(['201612'])
    events.each do |event|
      puts event.title
      record = Event.create(event_id: event.event_id,
        title: event.title,
        catch: event.catch,
        description: event.description,
        event_url: event.event_url,
        started_at: event.started_at,
        ended_at: event.ended_at,
        url: event.url,
        address: event.address,
        place: event.place,
        lat: event.lat,
        lon: event.lon,
        limit: event.limit,
        accepted: event.accepted,
        waiting: event.waiting,
        update_time: event.updated_at,
        hash_tag: event.hash_tag,
        place_enc: event.place_enc,
        source: event.source,
        group_url: event.group_url,
        group_id: event.group_id,
        group_title: event.group_title,
        group_logo: event.group_logo,
        logo: event.logo)
      puts "event:#{event.title}"
      event.users.each do |user|
        puts "user: #{user[:id]}"
        record.users.create(connpass_id: user[:id], twitter_id: user[:twitter_id], name: user[:name], image_url: user[:image])
      end
    end
  end
end
