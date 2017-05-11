module Api
  module Atnd
    class AtndEvent < Hashie::Mash
      include AtndScraping
      include EventFind

      def source
        'ATND'
      end

      def catch
        return "#{self[:catch]}<br>#{description}" if self[:catch].present?
        description
      end

      def description
        self[:description].gsub(/<\/?[^>]*>/, '').gsub(/\n+/, ' ')
      end

      def started_at
        Date.parse(self[:started_at])
      end
    end
  end
end
