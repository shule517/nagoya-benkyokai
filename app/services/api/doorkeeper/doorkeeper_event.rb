module Api
  module Doorkeeper
    class DoorkeeperEvent < Hashie::Mash
      include DoorkeeperScraping
      include EventFind

      def source
        'Doorkeeper'
      end

      def event_id
        self[:id]
      end

      def event_url
        self[:public_url]
      end

      def catch
        self[:description].gsub(/<\/?[^>]*>/, '').gsub(/\n+/, ' ')
      end

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
        Time.parse(self[:starts_at])
      end

      def ended_at
        Time.parse(self[:ends_at])
      end

      def update_time
        Time.parse(self[:updated_at])
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

      def limit_over? # TODO ちゃんとテストする Modelにもっていく
        return 0 if accepted == 0
        limit <= accepted
      end
    end
  end
end
