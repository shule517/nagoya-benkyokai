module Api
  module Doorkeeper
    class DoorkeeperApi
      def search(keyword: [], ym: [])
        keywords = Array(keyword)
        ym_list = Array(ym).sort!
        keywords.flat_map { |keyword| search_core(keywords, ym_list) }
      end

      def search_core(keywords, ym_list, start = 1)
        keyword_option = keywords.empty? ? '' : "&q=#{keywords}"
        since_option = ym_list.empty? ? '' : "&since=#{ym_list.first}01000000"
        until_option = ym_list.empty? ? '' : "&until=#{ym_list.last}31235959"
        url = "https://api.doorkeeper.jp/events/?sort=starts_at#{since_option}#{until_option}#{keyword_option}&page=#{start}"

        result = Shule::Http.get_json(url, Authorization: "Bearer #{ENV['DOORKEEPER_TOKEN']}")
        events = result.map { |hash| DoorkeeperEvent.new(hash[:event]) }
        return events + search_core(keywords, ym_list, start + 1) if events.count >= 20
        events
      rescue => e
        puts "rescue:#{e.class}"
      end
    end
  end
end
