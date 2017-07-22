module Api
  module Atnd
    class AtndEvent < Hashie::Mash
      include EventFindable
      include AtndScraping

      def source
        'atnd'
      end

      def catch
        # AtndApiのcatchは全て中身がからっぽ
        description.gsub(/<\/?[^>]*>/, '')
      end

      def event_url
        self[:event_url].gsub('http://', 'https://')
      end

      def started_at
        Time.parse(self[:started_at])
      end

      def ended_at
        Time.parse(self[:ended_at]) if self[:ended_at] # ATNDはendedが設定されていない場合がある
      end

      def updated_at
        Time.parse(self[:updated_at])
      end

      def update_time
        updated_at
      end
    end
  end
end
