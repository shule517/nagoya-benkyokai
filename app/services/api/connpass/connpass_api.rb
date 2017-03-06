module Api
  module Connpass
    class ConnpassApi
      def find(keyword: nil, ym: nil, event_id: '')
        search_core(Array(keyword), Array(ym), event_id).first
      end

      def search(keyword: nil, ym: nil, event_id: '')
        search_core(Array(keyword), Array(ym), event_id)
      end

      private

      SEARCH_MAX_COUNT = 100
      def search_core(keywords, ym_list, event_id, start = 0)
        url = request_url(keywords, ym_list, event_id, start)
        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| ConnpassEvent.new(hash) }
        next_start = result[:results_returned] + start
        continue = result[:results_available] > next_start

        if continue
          events + search_core(keywords, ym_list, event_id, next_start)
        else
          events
        end
      end

      def request_url(keywords, ym_list, event_id, start)
        "https://connpass.com/api/v1/event/?count=#{SEARCH_MAX_COUNT}&order=2&start=#{start + 1}".tap do |url|
          url << "&keyword_or=#{keywords.join(',')}" if keywords.present?
          url << "&event_id=#{event_id}" if event_id.present?
          url << ym_list.map { |ym| "&ym=#{ym}" }.join
        end
      end
    end
  end
end
