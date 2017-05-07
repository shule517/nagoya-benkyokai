module Api
  module Atnd
    class AtndEvent < Hashie::Mash
      include AtndScraping
      include EventFind

      def started_at
        Date.parse(self[:started_at])
      end
    end
  end
end
