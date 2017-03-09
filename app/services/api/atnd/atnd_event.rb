module Api
  module Atnd
    class AtndEvent < Hashie::Mash
      def atnd
        @atnd ||= AtndScraping.new(self)
      end

      def logo
        @logo ||= atnd.logo
      end

      def catch
        @catch ||= atnd.catch
      end

      def users
        @users ||= atnd.users
      end

      def owners
        @owners ||= atnd.owners
      end

      def started_at
        Date.parse(self[:started_at])
      end
    end
  end
end
