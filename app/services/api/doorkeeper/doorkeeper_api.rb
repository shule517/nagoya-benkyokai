module Api
  module Doorkeeper
    class DoorkeeperApi
      def search(args)
        set_param(args)
        search_core(1)
      end

      def find(args)
        search(args).first
      end

      private

      def set_param(keyword: [], ym: [], event_id: nil)
        @keywords = Array(keyword)
        @ym_list = Array(ym)
        @event_id = event_id
      end

      attr_reader :keywords, :ym_list, :event_id
      def search_core(start)
        result = Api::Http.get_json(request_url(start), Authorization: "Bearer #{ENV['DOORKEEPER_TOKEN']}")
        return [DoorkeeperEvent.new(result[:event])] if result.class == Hash
        events = result.map { |event| DoorkeeperEvent.new(event[:event]) }

        if events.count == 20
          events + search_core(start + 1)
        else
          events
        end
      rescue Net::HTTPServerException
        []
      end

      def request_url(start)
        if event_id.present?
          "https://api.doorkeeper.jp/events/#{event_id}"
        else
          "https://api.doorkeeper.jp/events/?sort=starts_at&page=#{start.to_s}".tap do |url|
            url << "&q=#{keywords.join('|')}" if keywords.present?
            url << "&since=#{ym_list.first}01000000" if ym_list.present?
            # url << "&until=#{ym_list.last}31235959" if ym_list.present?
          end
        end
      end
    end
  end
end
