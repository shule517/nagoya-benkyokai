module Api
  module Connpass
    class ConnpassEvent < Hashie::Mash
      include ConnpassScraping
      include EventFind

      def source
        'connpass'
      end

      def catch
        return "#{self[:catch]}<br>#{description}" if self[:catch].present?
        description
      end

      def description
        self[:description].gsub(/<\/?[^>]*>/, '').gsub(/\n+/, ' ')
      end

      def series
        self[:series] || { url: nil, id: nil, title: nil }
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
        Time.parse(self[:started_at])
      end

      def ended_at
        Time.parse(self[:ended_at])
      end

      def update_time
        Time.parse(self[:updated_at])
      end

      def limit_over? # TODO ちゃんとテストする Modelにもっていく
        return 0 if accepted == 0
        limit <= accepted
      end
    end
  end
end
