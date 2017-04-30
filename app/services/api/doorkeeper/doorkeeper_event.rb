module Api
  module Doorkeeper
    class DoorkeeperEvent < Hashie::Mash
      include DoorkeeperScraping

      def group_id
        self[:group]
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
