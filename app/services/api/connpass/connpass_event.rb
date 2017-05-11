module Api
  module Connpass
    class ConnpassEvent < Hashie::Mash
      include ConnpassScraping
      include EventFind

      def catch
        return "#{self[:catch]}<br>#{description}" if self[:catch].present?
        description
      end

      def description
        self[:description].gsub(/<\/?[^>]*>/, '').gsub(/\n+/, ' ')
      end

      def series
        self[:series] || { url: nil, group_id: nil, group_title: nil }
      end

      def group_url
        series[:url]
      end

      def group_id
        series[:id]
      end

      def group_title
        series[:title]
      end

      def started_at
        Date.parse(self[:started_at])
      end

      def limit_over?
        return 0 if accepted == 0
        limit <= accepted
      end
    end
  end
end
