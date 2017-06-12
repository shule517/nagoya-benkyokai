module Api
  module Doorkeeper
    class DoorkeeperEvent < Hashie::Mash
      include EventFindable
      include DoorkeeperScraping

      def source
        'doorkeeper'
      end

      def event_id
        self[:id]
      end

      def event_url
        self[:public_url]
      end

      def catch
        description.gsub(/<\/?[^>]*>/, '')
      end

      def place
        self[:venue_name]
      end

      def accepted
        self[:participants]
      end

      def lon
        self[:long]
      end

      def limit
        self[:ticket_limit]
      end

      def waiting
        self[:waitlisted]
      end

      def started_at
        self[:starts_at]
        # Time.parse(self[:starts_at])
      end

      def ended_at
        self[:ends_at]
        # Time.parse(self[:ends_at])
      end

      def update_time
        self[:updated_at]
        # Time.parse(self[:updated_at])
      end

      def group_id
        self[:group]
      end
    end
  end
end
