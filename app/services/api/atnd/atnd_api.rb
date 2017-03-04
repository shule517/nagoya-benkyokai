module Api
  module Atnd
    class AtndApi
      SEARCH_MAX_COUNT = 100

      def find(keyword: [], ym: [], event_id: '')
        search(keyword: keyword, ym: ym, event_id: event_id).first
      end

      def search(keyword: [], ym: [], event_id: '', start: 1)
        url = request_url(Array(keyword), Array(ym), event_id, start)
        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| AtndEvent.new(hash[:event]) }
        next_start = result[:results_start].to_i + result[:results_returned]
        if result[:results_returned] >= SEARCH_MAX_COUNT
          events + search(keyword: keyword, ym: ym, start: next_start)
        else
          events
        end
      end

      def request_url(keywords, ym_list, event_id, start)
        keyword_option = "&keyword_or=#{keywords.join(',')}" if keywords.present?
        ym_option = ym_list.map { |ym| "&ym=#{ym}" }.join
        event_id_option = "&event_id=#{event_id}" if event_id.present?
        "http://api.atnd.org/events/?count=#{SEARCH_MAX_COUNT}&order=2&format=json#{keyword_option}#{ym_option}#{event_id_option}&start=#{start}"
      end
    end
  end
end
