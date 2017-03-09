module Api
  module Doorkeeper
    class DoorkeeperEvent < Hashie::Mash
      def doorkeeper
        @doorkeeper ||= DoorkeeperScraping.new(self)
      end

      def group_url
        @group_url ||= doorkeeper.group_url
      end

      def group_title
        @group_title ||= doorkeeper.group_title
      end

      def logo
        @logo ||= doorkeeper.logo
      end

      def group_id
        self[:group]
      end

      def group_logo
        @group_logo ||= doorkeeper.group_logo
      end

      def users
        @users ||= doorkeeper.users
      end

      def owners
        @owners ||= doorkeeper.owners
      end

      def place
        self[:venue_name]
      end

      def accepted
        self[:participants]
      end

      def started_at
        Date.parse(self[:starts_at])
      end
    end
  end
end
