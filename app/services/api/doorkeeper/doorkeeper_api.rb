module Api
  module Doorkeeper
    class DoorkeeperApi
      SEARCH_MAX_COUNT = 20
      def search(keyword: [], ym: [])
        keywords = Array(keyword)
        ym_list = Array(ym).sort!
        keywords.flat_map { |keyword| search_core(keywords, ym_list) }
      end

      def search_core(keywords, ym_list, start = 1)
        url = request_url(keywords, ym_list, start)
        result = Shule::Http.get_json(url, Authorization: "Bearer #{ENV['DOORKEEPER_TOKEN']}")
        events = result.map { |hash| DoorkeeperEvent.new(hash[:event]) }
        if events.count >= SEARCH_MAX_COUNT
          events + search_core(keywords, ym_list, start + 1)
        else
          events
        end
      rescue => e
        puts "error:#{e.class}"
      end

      def request_url(keywords, ym_list, start)
        keyword_option = keywords.empty? ? '' : "&q=#{keywords}"
        since_option = ym_list.empty? ? '' : "&since=#{ym_list.first}01000000"
        until_option = ym_list.empty? ? '' : "&until=#{ym_list.last}31235959"
        "https://api.doorkeeper.jp/events/?sort=starts_at#{keyword_option}#{since_option}#{until_option}&page=#{start}"
      end
    end
  end
end
