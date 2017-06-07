module Api
  module Doorkeeper
    class DoorkeeperApi
      def find(keyword: [], ym: [], event_id: '')
        search_core(Array(keyword), Array(ym).sort!, event_id).first
      end

      def search(keyword: [], ym: [], event_id: '')
        search_core(Array(keyword), Array(ym).sort!, event_id)
      end

      private

      SEARCH_MAX_COUNT = 20
      def search_core(keywords, ym_list, event_id, start = 0)
        url = request_url(keywords, ym_list, event_id, start)
        result = Shule::Http.get_json(url)
        # result = Shule::Http.get_json(url, Authorization: "Bearer #{ENV['DOORKEEPER_TOKEN']}")
        return [DoorkeeperEvent.new(result[:event])] if result.class == Hash
        events = result.map { |hash| DoorkeeperEvent.new(hash[:event]) }
        continue = events.count >= SEARCH_MAX_COUNT

        if continue
          events + search_core(keywords, ym_list, event_id, start + 1)
        else
          events
        end
      rescue => e
        puts "error:#{e.class}"
        raise
      end

      def request_url(keywords, ym_list, event_id, start)
        if event_id.present?
          "https://api.doorkeeper.jp/events/#{event_id}"
        else
          "https://api.doorkeeper.jp/events/?sort=starts_at&page=#{start}".tap do |url|
            url << "&q=#{keywords}" if keywords.present?
            url << "&since=#{ym_list.first}01000000" if ym_list.present?
            url << "&until=#{ym_list.last}31235959" if ym_list.present?
          end
        end
      end
    end
  end
end
