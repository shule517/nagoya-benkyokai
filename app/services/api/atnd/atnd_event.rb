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

      def group_url
        nil # TODO 未実装
      end

      def group_id
        nil # TODO 未実装
      end

      def group_title
        nil # TODO 未実装
      end

      def group_logo
        nil # TODO 未実装
      end
    end
  end
end
