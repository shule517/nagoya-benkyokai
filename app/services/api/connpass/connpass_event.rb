module Api
  module Connpass
    class ConnpassEvent < Hashie::Mash
      def connpass
        @connpass ||= ConnpassScraping.new(self)
      end

      def logo
        @logo ||= connpass.logo
      end

      def group_logo
        @group_logo ||= connpass.group_logo
      end

      def users
        @users ||= connpass.users
      end

      def owners
        @owners ||= connpass.owners
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
