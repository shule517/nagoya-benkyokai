module Api
  module Connpass
    class ConnpassApi
      def search(args)
        set_param(args)
        search_core(1)
      end

      def find(args)
        set_param(args)
        search_core(1).first
      end

      private

      attr_reader :keywords, :ym_list, :event_id
      def set_param(keyword: [], ym: [], event_id: nil)
        @keywords = Array(keyword)
        @ym_list = Array(ym)
        @event_id = event_id
      end

      def search_core(start)
        result = Api::Http.get_json(request_url(start))

        next_start = result[:results_start] + result[:results_returned]
        events = result[:events].map { |event| ConnpassEvent.new(event) }

        if next_start < result[:results_available]
          events + search_core(next_start)
        else
          events
        end
      end

      def request_url(start)
        "https://connpass.com/api/v1/event/?start=#{start.to_s}&count=100&order=2".tap do |url|
          url << "&event_id=#{event_id}" if event_id.present?
          url << "&keyword_or=#{keywords.join(',')}" if keywords.present?
          url << ym_list.map { |ym| "&ym=#{ym}" }.join
        end
      end
    end
  end
end
