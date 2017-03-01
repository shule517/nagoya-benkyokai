module Api
  module Atnd
    class AtndApi
      SEARCH_MAX_COUNT = 100
      def search(keyword: [], ym: [], start: 0)
        url = request_url(Array(keyword), Array(ym), start)
        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| AtndEvent.new(hash) }
        next_start = result[:results_start].to_i + result[:results_returned]
        if result[:results_returned] >= SEARCH_MAX_COUNT
          events + search(keyword: keyword, ym: ym, start: next_start) 
        else
          events
        end
      end

      def request_url(keywords, ym_list, start)
        keyword_option = keywords.empty? ? '' : "&keyword_or=#{keywords.join(',')}"
        ym_option = ym_list.map { |ym| "&ym=#{ym}" }.join
        "http://api.atnd.org/events/?count=#{SEARCH_MAX_COUNT}&order=2&format=json#{keyword_option}#{ym_option}&start=#{start + 1}"
      end
    end
  end
end
