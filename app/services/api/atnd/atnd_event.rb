module Api
  module Atnd
    class AtndEvent < Hashie::Mash
      include AtndScraping

      def started_at
        Date.parse(self[:started_at])
      end
    end
  end
end
