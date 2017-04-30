module Api
  module Connpass
    class ConnpassApi
      attr_reader :keywords, :ym_list, :event_id
      def initialize(keyword: nil, ym: nil, event_id: nil)
        @keywords = Array(keyword)
        @ym_list = Array(ym)
        @event_id = event_id
      end

      class << self
        def find(args)
          new(args).find
        end

        def search(args)
          new(args).search
        end
      end

      def find
        search_core.first
      end

      def search
        search_core
      end

      private

      SEARCH_MAX_COUNT = 100
      def search_core(start = 0)
        url = request_url(start)
        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| ConnpassEvent.new(hash) }
        next_start = result[:results_returned] + start
        continue = result[:results_available] > next_start

        if continue
          events + search_core(next_start)
        else
          events
        end
      end

      def request_url(start)
        "https://connpass.com/api/v1/event/?count=#{SEARCH_MAX_COUNT}&order=2&start=#{start + 1}".tap do |url|
          url << "&keyword_or=#{keywords.join(',')}" if keywords.present?
          url << "&event_id=#{event_id}" if event_id.present?
          url << ym_list.map { |ym| "&ym=#{ym}" }.join
        end
      end
    end
  end
end
