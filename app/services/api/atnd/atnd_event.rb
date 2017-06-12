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

      def update_time
        self[:updated_at]
        # Time.parse(self[:updated_at])
      end
    end
  end
end
