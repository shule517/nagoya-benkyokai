module Api
  module Atnd
    class AtndApi
      def find(keyword: [], ym: [], event_id: '')
        search_core(Array(keyword), Array(ym), event_id).first
      end

      def search(keyword: [], ym: [], event_id: '')
        search_core(Array(keyword), Array(ym), event_id)
      end

      private

      SEARCH_MAX_COUNT = 100
      def search_core(keywords, ym_list, event_id, start = 1)
        url = request_url(keywords, ym_list, event_id, start)
        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| AtndEvent.new(hash[:event]) }
        next_start = result[:results_start].to_i + result[:results_returned]
        continue = result[:results_returned] >= SEARCH_MAX_COUNT

        if continue
          events + search_core(keywords, ym_list, event_id, next_start)
        else
          events
        end
      end

      def request_url(keywords, ym_list, event_id, start)
        "http://api.atnd.org/events/?count=#{SEARCH_MAX_COUNT}&order=2&format=json&start=#{start}".tap do |url|
          url << "&keyword_or=#{keywords.join(',')}" if keywords.present?
          url << ym_list.map { |ym| "&ym=#{ym}" }.join
          url << "&event_id=#{event_id}" if event_id.present?
        end
      end
    end
  end
end
