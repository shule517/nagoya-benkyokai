module Api
  module Atnd
    class AtndEvent < Hashie::Mash
      include AtndScraping
      include EventFind

      def source
        'ATND'
      end

      def event_url
        self[:event_url].gsub('http://', 'https://')
      end

      def catch
        return "#{self[:catch]}<br>#{description}" if self[:catch].present?
        description
      end

      def description
        self[:description].gsub(/<\/?[^>]*>/, '').gsub(/\n+/, ' ')
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

      def hash_tag
      end

      def limit_over? # TODO ちゃんとテストする
        return 0 if accepted == 0
        limit <= accepted
      end
    end
  end
end
