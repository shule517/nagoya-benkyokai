module Api
  module Connpass
    class ConnpassApi
      SEARCH_MAX_COUNT = 100
      def search(keyword: nil, ym: nil, event_id: '', start: 0)
        url = request_url(Array(keyword), Array(ym), event_id, start)
        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| ConnpassEvent.new(hash) }
        next_start = start + result[:results_returned]
        if result[:results_available] > next_start
          events + search(keyword: keyword, ym: ym, start: next_start)
        else
          events
        end
      end

      def request_url(keywords, ym_list, event_id, start)
        keyword_option = keywords.blank? ? '' : "&keyword_or=#{keywords.join(',')}"
        ym_option = ym_list.map { |ym| "&ym=#{ym}" }.join
        event_id_option = event_id.blank? ? '' : "&event_id=#{event_id}"
        "https://connpass.com/api/v1/event/?count=#{SEARCH_MAX_COUNT}&order=2#{keyword_option}#{ym_option}#{event_id_option}&start=#{start + 1}"
      end
    end
  end
end
