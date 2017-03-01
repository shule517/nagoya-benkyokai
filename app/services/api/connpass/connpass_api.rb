module Api
  module Connpass
    class ConnpassApi
      SEARCH_MAX_COUNT = 100
      def search(keyword: nil, ym: nil, start: 0)
        url = request_url(Array(keyword), Array(ym), start)
        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| ConnpassEvent.new(hash) }
        next_start = start + result[:results_returned]
        if result[:results_available] > next_start
          events + search(keyword: keyword, ym: ym, start: next_start)
        else
          events
        end
      end

      def request_url(keywords, ym_list, start)
        keyword_option = keywords.empty? ? '' : "&keyword_or=#{keywords.join(',')}"
        ym_option = ym_list.map { |ym| "&ym=#{ym}" }.join
        "https://connpass.com/api/v1/event/?count=#{SEARCH_MAX_COUNT}&order=2#{keyword_option}#{ym_option}&start=#{start + 1}"
      end
    end
  end
end
