module Api
  module Atnd
    class AtndApi
      attr_reader :keywords, :ym_list, :event_id
      def initialize(keyword: [], ym: [], event_id: nil)
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
      def search_core(start = 1)
        url = request_url(start)
        result = Shule::Http.get_json(url)
        events = result[:events].map { |hash| AtndEvent.new(hash[:event]) }
        next_start = result[:results_start].to_i + result[:results_returned]
        continue = result[:results_returned] >= SEARCH_MAX_COUNT

        if continue
          events + search_core(next_start)
        else
          events
        end
      end

      def request_url(start)
        "http://api.atnd.org/events/?count=#{SEARCH_MAX_COUNT}&order=2&format=json&start=#{start}".tap do |url|
          url << "&keyword_or=#{keywords.join(',')}" if keywords.present?
          url << ym_list.map { |ym| "&ym=#{ym}" }.join
          url << "&event_id=#{event_id}" if event_id.present?
        end
      end
    end
  end
end
