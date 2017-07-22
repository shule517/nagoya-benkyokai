module Api
  module EventFindable
    def find_or_initialize_by
      event = Event.find_by(event_id: event_id)
      if event
        event.title = title
        event.catch = self.catch
        event.description = description
        event.event_url = event_url
        event.started_at = started_at
        event.ended_at = ended_at
        event.url = url
        event.address = address
        event.place = place
        event.lat = lat
        event.lon = lon
        event.limit = limit
        event.accepted = accepted
        event.waiting = waiting
        event.update_time = updated_at
        event.hash_tag = hash_tag
        event.place_enc = place_enc
        event.source = source
        event.group_url = group_url
        event.group_id = group_id
        event.group_title = group_title
        event.group_logo_url = group_logo_url
        event.logo_url = logo_url
        return event
      end

      Event.new(event_id: event_id,
        title: title,
        catch: self.catch,
        description: description,
        event_url: event_url,
        started_at: started_at,
        ended_at: ended_at,
        url: url,
        address: address,
        place: place,
        lat: lat,
        lon: lon,
        limit: limit,
        accepted: accepted,
        waiting: waiting,
        update_time: updated_at,
        hash_tag: hash_tag,
        place_enc: place_enc,
        source: source,
        group_url: group_url,
        group_id: group_id,
        group_title: group_title,
        group_logo_url: group_logo_url,
        logo_url: logo_url)
    end

    def place_enc
      URI.escape(place)
    end

    def limit_over?
      return 0 if accepted == 0
      limit <= accepted
    end
  end
end
