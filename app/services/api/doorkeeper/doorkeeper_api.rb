module Api
  module Doorkeeper
    class DoorkeeperApi
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

      SEARCH_MAX_COUNT = 20
      def search_core(start = 0)
        url = request_url(start)
        result = Shule::Http.get_json(url, Authorization: "Bearer #{ENV['DOORKEEPER_TOKEN']}")
        return [DoorkeeperEvent.new(result[:event])] if result.class == Hash
        events = result.map { |hash| DoorkeeperEvent.new(hash[:event]) }
        continue = events.count >= SEARCH_MAX_COUNT

        if continue
          events + search_core(start + 1)
        else
          events
        end
      rescue => e
        puts "error:#{e.class}"
        raise
      end

      def request_url(start)
        if event_id.present?
          "https://api.doorkeeper.jp/events/#{event_id}"
        else
          "https://api.doorkeeper.jp/events/?sort=starts_at&page=#{start}".tap do |url|
            url << "&q=#{keywords}" if keywords.present?
            url << "&since=#{ym_list.first}01000000" if ym_list.present?
            url << "&until=#{ym_list.last}31235959" if ym_list.present?
          end
        end
      end
    end
  end
end
