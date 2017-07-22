module Api
  module Connpass
    class ConnpassEvent < Hashie::Mash
      include EventFindable
      include ConnpassScraping

      def source
        'connpass'
      end

      def catch
        desc = self[:description].gsub(/<\/?[^>]*>/, '')
        if self[:catch].present?
          "#{self[:catch]}<br>#{desc}"
        else
          desc
        end
      end

      def started_at
        Time.parse(self[:started_at])
      end

      def ended_at
        Time.parse(self[:ended_at])
      end

      def updated_at
        Time.parse(self[:updated_at])
      end

      def update_time
        updated_at
      end

      def series
        self[:series] || {}
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
    end
  end
end
