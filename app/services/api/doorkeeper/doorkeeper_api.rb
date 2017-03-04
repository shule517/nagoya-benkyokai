module Api
  module Doorkeeper
    class DoorkeeperApi
      SEARCH_MAX_COUNT = 20

      def find(keyword: [], ym: [], event_id: '')
        search(keyword: keyword, ym: ym, event_id: event_id).first
      end

      def search(keyword: [], ym: [], event_id: '')
        keywords = Array(keyword)
        ym_list = Array(ym).sort!
        search_core(keywords, ym_list, event_id)
      end

      def search_core(keywords, ym_list, event_id, start = 1)
        url = request_url(keywords, ym_list, event_id, start)
        result = Shule::Http.get_json(url, Authorization: "Bearer #{ENV['DOORKEEPER_TOKEN']}")
        return [DoorkeeperEvent.new(result[:event])] if result.class == Hash
        events = result.map { |hash| DoorkeeperEvent.new(hash[:event]) }
        if events.count >= SEARCH_MAX_COUNT
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
          keyword_option = "&q=#{keywords}" if keywords.present?
          since_option = "&since=#{ym_list.first}01000000" if ym_list.present?
          until_option = "&until=#{ym_list.last}31235959" if ym_list.present?
          event_id_option = "&event_id=#{event_id}" if event_id.present?
          "https://api.doorkeeper.jp/events/?sort=starts_at#{keyword_option}#{since_option}#{until_option}#{event_id_option}&page=#{start}"
        end
      end
    end
  end
end
